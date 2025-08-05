# Locality Refresh Leakage Capture Script

import argparse
import configparser
import csv
import json
import logging
import time
from pathlib import Path

import chipwhisperer as cw
import numpy as np
from tqdm import tqdm

logging.basicConfig(format="%(asctime)s:%(levelname)s:%(message)s")
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

SCOPETYPE = "OPENADC"
SS_VER = "SS_VER_1_1"
PLATFORM = "CWLITE"


def saidoyoki_reset(scope_obj):
    scope_obj.io.tio3 = "gpio_low"
    time.sleep(0.5)
    scope_obj.io.tio3 = "high_z"


if __name__ == "__main__":
    # Parse arguments
    parser = argparse.ArgumentParser(description="Capture traces for Locality Refresh.")
    parser.add_argument("vectors", help="Name of the test vectors CSV file.")
    parser.add_argument("-t", "--type", choices=["int", "float"], default="int", help="Data type to use in traces files.")
    parser.add_argument("-s", "--suffix", help="Add a suffix to the traces folder.")
    parser.add_argument("--debug", action="store_true", help="Set log level to DEBUG.")
    args = parser.parse_args()
    print(args)
    if args.type == "int":
        use_int = True
    else:
        use_int = False
    if args.debug:
        logger.setLevel(logging.DEBUG)
    # Read config file
    if args.suffix is None:
        folder_name = args.vectors
    else:
        folder_name = args.vectors + "_" + args.suffix
    # Read config file
    config = configparser.ConfigParser()
    config.read("config/settings.ini")
    csv_path = Path(config["CSV"]["csv_path"])
    traces_path = Path(config["CAPTURE"]["traces_path"] + "/" + folder_name + "/")
    sample_points = int(config["CAPTURE"]["sample_points"])
    offset = int(config.get("CAPTURE", "offset", fallback="0"))
    clkgen_freq = int(config["CAPTURE"]["clkgen_freq"])
    adc_mul = int(config.get("HUSKY", "adc_mul", fallback="4"))

    logger.info(("-" * 20) + args.vectors + ("-" * 20))
    logger.info(f"Stimuli path: {csv_path}")
    logger.info(f"Sample points: {sample_points:,}")
    if not csv_path.exists():
        logger.error("CSV directory does not exists")
        exit(1)
    csv_spec = csv_path.joinpath(f"definition/{args.vectors}.json")
    if not csv_spec.exists():
        logger.error("JSON definition does not exist")
        exit(1)

    with open(csv_spec) as json_file:
        json_data = json.load(json_file)

    traces_num = json_data["number"]
    response_length = json_data["size"]
    logger.info(f"Number of traces: {traces_num:,}")
    logger.info(f"Response length: {response_length}")
    
    # vector format for microbenchmarks
    #    group, iregs, code, oregs [1 byte, 32 bytes, 32 bytes, 32 bytes]
    #    group = group id for tvla
    #    iregs = 8 words loaded in a0 .. a7
    #    code  = 8 words corresponding to a microbenchmark (16 instructions for picorv)
    #    oregs = 8 wors result data in a0 .. a7
    # first (inclusive) and last (exclusive) testvector, counted by line in STIMULI
    logger.info(f"Configuring scope for {traces_num:,} traces of {sample_points:,} points.")
    # file with group, key, pt, ct pairs

    stimuli_file = csv_path.joinpath(f"{args.vectors}.csv")
    logger.info(f"Simuli file: {stimuli_file}")
    if not stimuli_file.exists():
        logger.error("Stimuli CSV file not found.")
        exit(1)

    try:
        if not scope.connectStatus:
            scope.con()
    except NameError:
        scope = cw.scope(scope_type=cw.scopes.OpenADC)

    try:
        target = cw.target(scope)
    except IOError:
        logger.info("Caught exception on reconnecting to target - attempting to reconnect to scope first.")
        logger.info("This is a work-around when USB has died without Python knowing. Ignore errors above this line.")
        scope = cw.scope()
        target = cw.target(scope)

    scope.glitch_disable()
    scope.default_setup()
    scope.adc.samples = sample_points
    scope.adc.offset = offset
    scope.adc.basic_mode = "rising_edge"
    scope.clock.clkgen_freq = clkgen_freq
    scope.clock.adc_phase = 0

    # chipwhisperer settings
    if scope.get_name() == "ChipWhisperer Lite":
        scope.clock.adc_src = "clkgen_x4"
        scope.gain.db = int(config.get("LITE", "gain_db", fallback=25))
    elif scope.get_name() == "ChipWhisperer Husky":
        try:
            scope.clock.clkgen_src = "system"
            scope.clock.clkgen_freq = clkgen_freq
            scope.clock.adc_mul = adc_mul
            scope.gain.db = int(config.get("HUSKY", "gain_db", fallback=25))
            scope.adc.stream_mode = eval(config.get("HUSKY", "stream_mode", fallback="False"))
        except ValueError:
            print("check Husky clock freq ", scope.clock.clkgen_freq, " locked ", scope.clock.clkgen_locked,)
            
    scope.trigger.triggers = "tio4"
    scope.io.tio1 = "serial_tx"
    scope.io.tio2 = "serial_rx"
    scope.io.hs2 = "clkgen"
    scope.errors.clear()

    # show debug info
    if logger.getEffectiveLevel() == logging.DEBUG:
        print(scope)

    saidoyoki_reset(scope)
    for _ in tqdm(range(5), desc="Completing board reset"):
        time.sleep(1)

    # ----------------------------------------------------------
    # load testvectors
    
    pload_array = []
    res_array = []
    with open(stimuli_file, newline="") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # Construct input: a0,a1,b0,b1,r,c0,c1
            input_str = (
                row["a0"] + row["a1"] +
                row["r"] + row["c0"] + row["c1"]
            ).lower()
            output_str = row["expected_value"].lower()

            pload_array.append(input_str)
            res_array.append(output_str)

    if len(pload_array) < traces_num:
        logger.error(f"Need {traces_num:,} vectors, found {len(pload_array):,}")
        exit(1)

    # ----------------------------------------------------------
    # start capture
    if not traces_path.exists():
        traces_path.mkdir(parents=True)
    trace_filename = traces_path.joinpath(f"{args.vectors}.traces.npy")
    trace_shape = (traces_num, sample_points)
    trace_dtype = np.dtype(np.int16) if use_int else np.dtype(np.float32)
    trace_map = np.memmap(trace_filename.as_posix(), dtype=trace_dtype, mode="w+", shape=trace_shape)

    response_array = []

    logger.info(f"Capturing {traces_num:,} traces")
    logger.info(f"Expecting vectors of length {response_length}")

    scope.errors.clear()

    for n in tqdm(range(traces_num)):
        target.simpleserial_write("p", bytes.fromhex(pload_array[n]))
        if target.simpleserial_wait_ack() is None:
            logger.error(f"Trace {n:,}: No ACK received!")
            exit(1)

        timed_out = True
        while timed_out:
            scope.arm()
            target.simpleserial_write("p", bytes.fromhex(pload_array[n]))
            if timed_out := scope.capture(poll_done=True):
                logger.warning(f"Trace {n:,}: Target timed out!")

        try:
            response = target.simpleserial_read("r", response_length)
        except Exception as e:
            print(e)
            exit(1)

        if response:
            response_array.append(response.hex())
            trace_map[n] = scope.get_last_trace(as_int=use_int)
        else:
            logger.warning(f"Trace {n:,}: No response received!")

    trace_map.flush()
    del trace_map

    cw_info = {
        "gain": scope.gain.db,
        "clkgen_src": scope.clock.clkgen_src,
        "clkgen_freq": scope.clock.clkgen_freq,
        "adc_mul": scope.clock.adc_mul,
        "bits_per_sample": scope.adc.bits_per_sample,
        "decimate": scope.adc.decimate,
        "offset": scope.adc.offset,
        "presamples": scope.adc.presamples,
        "trig_count": scope.adc.trig_count,
        "stream_mode": scope.adc.stream_mode,
        "model": scope.get_name(),
        "sn": scope.sn,
        "error": scope.errors.adc.errors,
    }
    scope.dis()

    # ----------------------------------------------------------
    # save
    
    logger.info("Saving vectors")
    np.savez_compressed(
        traces_path.joinpath(f"{args.vectors}.data.npz"),
        payload=pload_array[:traces_num],
        response=response_array,
    )
    metadata = {
        "traces": traces_num,
        "samples": sample_points,
        "type": trace_dtype.str,
        "scope": cw_info,
    }
    with open(traces_path.joinpath(f"{args.vectors}.meta.json"), "w") as json_file:
        json.dump(metadata, json_file)
