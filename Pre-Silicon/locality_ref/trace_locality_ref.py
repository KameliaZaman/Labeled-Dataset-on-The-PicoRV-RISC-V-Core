
"""
-----------------------
version 0.1
added the type column to the read instructions
Last update: 21Feb 2024
-----------------------
"""

from capstone import Cs
from qiling import Qiling
from qiling.const import QL_VERBOSE
from unicorn import UC_PROT_ALL
from binascii import unhexlify, hexlify
from elftools.elf.elffile import ELFFile
from collections import defaultdict



import sys
import os
import csv
import pandas as pd
#import numpy as np


riscv_registers ={'x0':'zero', 'x1':'ra', 'x2':'sp','x3':'gp', 'x4':'tp',
                  'x5':'t0','x6':'t1','x7':'t2',
              'x8':'s0','x9':'s1',
             'x10':'a0','x11':'a1','x12':'a2','x13':'a3','x14':'a4','x15':'a5','x16':'a6','x17':'a7',
              'x18':'s2','x19':'s3', 'x20':'s4','x21':'s5','x22':'s6','x23':'s7','x24':'s8','x25':'s9','x26':'s10','x27':'s11',
              'x28':'t3','x29':'t4','x30':'t5','x31':'t6'}

RV32I = {
        'LOAD': ['LUI', 'LB', 'LH', 'LW', 'LBU', 'LHU'],
        'STORE': ['SB', 'SH', 'SW'],
        'LOGICAL': ['XORI', 'ORI', 'ANDI', 'XOR', 'OR', 'AND'],
        'ARITHMETIC': ['ADDI', 'SLTI', 'SLTIU', 'ADD', 'SUB', 'SLT', 'SLTU'],
        'SHIFT': ['SLLI', 'SRLI', 'SRAI', 'SLL', 'SRL', 'SRA'],
        'CBRANCH': ['BEQ', 'BNE', 'BLT', 'BGE', 'BLTU', 'BGEU'],
        'UBRANCH': ['JAL', 'JALR'],
        'ATOMIC': ['CSRRW', 'CSRRS', 'CSRRC', 'CSRRWI', 'CSRRSI', 'CSRRCI'],
        'ENV': ['AUIPC', 'FENCE', 'ECALL', 'EBREAK', 'FENCE.I'],
        }
RV32C = {
        'LOAD': ['C.LW', 'C.LUI', 'C.LWSP'],
        'STORE': ['C.SW', 'C.SWSP'],
        'LOGICAL': ['C.ANDI', 'C.XOR', 'C.OR', 'C.AND'],
        'ARITHMETIC': ['C.LI', 'C.ADDI4SPN', 'C.ADDI16SP', 'C.NOP', 'C.ADDI', 'C.SUB', 'C.MV', 'C.ADD'],
        'SHIFT': ['C.SRLI', 'C.SRAI', 'C.SLLI'],
        'CBRANCH': ['C.BEQZ', 'C.BNEZ'],
        'UBRANCH': ['C.JAL', 'C.J', 'C.JR', 'C.JALR'],
        'ENV': ['C.EBREAK'],
        }
RV32M = {
        'ARITHMETIC': ['MUL', 'MULH', 'MULHSU', 'MULHU', 'DIV', 'DIVU', 'REM', 'REMU'],
        }
RV32A = {
        'ATOMIC': ['LR.W','SC.W','AMOSWAP.W','AMOADD.W','AMOXOR.W','AMOAND.W','AMOOR.W','AMOMIN.W','AMOMAX.W','AMOMINU.W','AMOMAXU.W'],
        }
PSEUDO = {
        'LOAD': ['LA', 'LLA', 'LI'],
        'LOGICAL': ['NOT'],
        'ARITHMETIC': ['NOP', 'MV', 'NEG', 'NEGW', 'SEXT.W', 'SEQZ', 'SNEZ', 'SLTZ', 'SGTZ'],
        'CBRANCH': ['BEQZ', 'BNEZ', 'BLEZ', 'BGEZ', 'BLTZ', 'BGTZ', 'BGT', 'BLE', 'BGTU', 'BLEU'],
        'UBRANCH': ['J', 'JR', 'RET', 'CALL', 'TAIL'],
        }
        

headerList=['PC','Machine','Ins','Type','Operands', 'zero', 'ra', 'sp','gp', 'tp','t0','t1','t2','s0','s1','a0','a1','a2','a3','a4','a5','a6','a7','s2','s3', 's4','s5','s6','s7','s8','s9','s10','s11','t3','t4','t5','t6']


def  return_instruction_type (instruction): 
    """
    instruction(str): a riscv instruction 
    returns the type of the instruction and the extension values ={'i','c','m','a','p'}
    """
  
    type_instruction='Unknown'
    extension ='Unknown'
 
    if instruction in RV32I['LOAD']+RV32C['LOAD']+PSEUDO['LOAD']:
        type_instruction='LOAD'
        if instruction in RV32I['LOAD']:
             extension ='i'
        elif instruction in RV32C['LOAD']:
             extension ='c'
        else:
            extension ='p'
    elif instruction in RV32I['STORE']+RV32C['STORE']:
        type_instruction='STORE'
        if instruction in RV32I['STORE']:
             extension ='i'
        else:
            extension ='c'
    elif instruction in RV32I['LOGICAL']+RV32C['LOGICAL']+PSEUDO['LOGICAL']:
        type_instruction='LOGICAL'
        if instruction in RV32I['LOGICAL']:
            extension ='i'
        elif instruction in RV32C['LOGICAL']:
            extension ='c'
        else:
            extension ='p'
    elif instruction in RV32I['ARITHMETIC']+RV32C['ARITHMETIC']+RV32M['ARITHMETIC']+PSEUDO['ARITHMETIC']:
        type_instruction='ARITHMETIC'
        if instruction in RV32I['ARITHMETIC']:
             extension ='i'
        elif instruction in RV32C['ARITHMETIC']:
             extension ='c'
        elif instruction in RV32M['ARITHMETIC']:
             extension ='m'
        else:
            extension ='p'
    elif instruction in RV32I['SHIFT']+RV32C['SHIFT']:
        type_instruction='SHIFT'
        if instruction in RV32I['SHIFT']:
             extension ='i'
        else:
            extension ='c'
    elif instruction in RV32I['CBRANCH']+RV32C['CBRANCH']+PSEUDO['CBRANCH']:
        type_instruction='CBRANCH'
        if instruction in RV32I['CBRANCH']:
             extension ='i'
        elif instruction in RV32C['CBRANCH']:
             extension ='c'
        else:
            extension ='p'
    elif instruction in RV32I['UBRANCH']+RV32C['UBRANCH']+PSEUDO['UBRANCH']:
        type_instruction='UBRANCH'
        if instruction in RV32I['UBRANCH']:
             extension ='i'
        elif instruction in RV32C['UBRANCH']:
            extension ='c'
        else:
            extension ='p'
    elif instruction in RV32I['ATOMIC']+RV32A['ATOMIC']:
        type_instruction='ATOMIC'
        if instruction in RV32I['ATOMIC']:
             extension ='i'
        else:
            extension ='a'
    elif instruction in RV32I['ENV']+RV32C['ENV']:
        type_instruction='ENV'
        if instruction in RV32I['ENV']:
             extension ='i'
        else:
            extension ='c'
    return type_instruction, extension

def get_symbol_by_name(elf, name):
	"""
	Takes an ELFFile and a name, returns the address of the given symbol in the file. 
	"""

	symtab = elf.get_section_by_name('.symtab')
	sym = symtab.get_symbol_by_name(name)
	if sym is None:
		return None

	return sym[0]['st_value']


def read_metadata(dataframe, number_traces):
    """
    Reads a dataframe and returns a0, a1, and r values for the first number_traces entries.
    """
    a0_list = dataframe['a0'].tolist()[:number_traces]
    a1_list = dataframe['a1'].tolist()[:number_traces]
    r_list  = dataframe['r'].tolist()[:number_traces]

    return a0_list, a1_list, r_list

def code_hook(ql: Qiling, address: int, size: int, md: Cs) -> None:
    """
    This function  gets executed for every instruction. We're writing the PC, instruction and all register contents into a file
    """
    row=[address]
    for reg in riscv_registers:
        row.append(hex(ql.arch.regs.read(riscv_registers[reg])))
    writer.writerow(row)


def code_hook(ql: Qiling, address: int, size: int, md: Cs) -> None:
    """
    This function  gets executed for every instruction. We're writing the PC, instruction and all register contents into a file
    """
    buf = ql.mem.read(address, size)
    #preparing the instruction definition 
    read_ins=[]
    for insn in md.disasm(buf, address):
        read_ins.append(hex(insn.address)) #PC
        read_ins.append(buf.hex()) #machine code
        read_ins.append(insn.mnemonic) #mnemonic
        #read_ins.append(return_instruction_type(insn.mnemonic))
        read_ins.append(return_instruction_type(insn.mnemonic.upper())[0])
        read_ins.append(insn.op_str) #parameters
        #'Machine','Ins','Type','Operands'

    #print(read_ins)
    #ql.log.debug(f"====== PC: {ql.arch.regs.pc: #x} ======")
   
    row=read_ins #initializa the row with instruction information
    for reg in riscv_registers:
        row.append(hex(ql.arch.regs.read(riscv_registers[reg])))
    writer.writerow(row)


def itb(num):
    # Convert the integer to a 32-bit bytearray
    byte_array = num.to_bytes(4, byteorder='little', signed=False)

    return byte_array

def htb(hex_string):
    # Split the hexadecimal string into 16-byte chunks
    chunks = [hex_string[i:i+16] for i in range(0, len(hex_string), 16)]

    # Convert each chunk to bytes and concatenate them
    byte_array = b"".join(bytes.fromhex(chunk) for chunk in chunks)

    return byte_array

def mem_write_invalid(ql: Qiling, access: int, address: int, size: int, value: int) -> None:
	"""
	This function would get executed if invalid memory was written to. Can be useful for 
	debugging issues with emulation. Take a look at https://docs.qiling.io/en/latest/hook/
	for more info
	"""
	ql.log.debug(f'intercepted a invalid memory write to {address:#x} (value = {value:#x})')
	pc = ql.arch.regs.pc
	ql.log.debug(f'PC is: {pc: #x}')
   

if __name__ == "__main__":
    fname = sys.argv[1]
    number_of_traces = int(sys.argv[2])
    random_data = 'tv_locality_refresh.csv' # CSV file with a0, a1, r
    output_prefix = sys.argv[4]  # e.g., "trace_out/"

    if fname[0] != "/":
        fname = os.path.join(os.getcwd(), fname)
    print(f"[+] Emulating {fname}")

    data = pd.read_csv(random_data)
    a0_list, a1_list, r_list = read_metadata(data, number_of_traces)
    
    # ELF symbol loading
    elf = ELFFile(open(fname, "rb"))
    get_payload = get_symbol_by_name(elf, "locality_refresh")
    main = get_symbol_by_name(elf, "main")

    ql = Qiling([fname], rootfs="/", verbose=QL_VERBOSE.OFF)
    ql.mem.map(0x03000000, 0x01000000, UC_PROT_ALL, "memory mapped io")
    ql.mem.map(0x02000000, 0x00001000, UC_PROT_ALL, "serial peripheral")

    disassembler = ql.arch.disassembler
    global writer

    ql.hook_code(lambda ql, addr, size: code_hook(ql, addr, size, disassembler))

    original_sp = ql.arch.regs.sp
    for i in range(number_of_traces):
        print(f"Trace {i} is being generated...")

        ql.arch.regs.a0 = int(a0_list[i], 16)
        ql.arch.regs.a1 = int(a1_list[i], 16)
        ql.arch.regs.a2 = int(r_list[i], 16) if isinstance(r_list[i], str) else int(r_list[i])
        ql.arch.regs.ra = main
        ql.arch.regs.sp = original_sp

        name_trace_file = f"trace_{i}.csv"
        with open(name_trace_file, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(headerList)
            ql.run(begin=get_payload, end=main)

