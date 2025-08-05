CROSSCPP= riscv64-unknown-elf-cpp 
CROSSGCC= riscv64-unknown-elf-gcc 
CROSSOBJDUMP= riscv64-unknown-elf-objdump 
CROSSOBJCOPY= riscv64-unknown-elf-objcopy
CROSSSIZE= riscv64-unknown-elf-size
OFLAG?=-O2
MASK?=0
CFLAGS=-Wall $(OFLAG) -march=rv32i -mabi=ilp32 -I/usr/lib/picolibc/riscv64-unknown-elf/include
LDFLAGS=-L/usr/lib/picolibc/riscv64-unknown-elf/lib -lc
CLOCK_FREQ?=1

all: picoboot.elf picoapp.elf firmware.bin

picoboot.elf: picoboot.c memorymap.ld bootloader.ld
	$(CROSSGCC) \
		$(CFLAGS) \
		-Wl,-Bstatic,-T,bootloader.ld,--strip-debug \
		-nostdlib \
		-ffreestanding \
		-o picoboot.elf \
		start.s \
		picoboot.c \
		$(LDFLAGS)
	$(CROSSSIZE) picoboot.elf

picoboot.s: picoboot.elf
	$(CROSSOBJDUMP) --disassemble picoboot.elf > picoboot.s

picoboot.bin: picoboot.elf
	$(CROSSOBJCOPY) -O binary picoboot.elf picoboot.ubin
	$(CROSSOBJCOPY) -F binary --pad-to 0x010000 --gap-fill 0xFF picoboot.ubin picoboot.bin

picoapp.elf: start.s hal.c simpleserial.c locality_ref.S main_locality_ref.c
	$(CROSSGCC) \
		$(CFLAGS) -save-temps \
		$(APP_FLAGS) \
		-Wl,-Bstatic,-T,app.ld,--strip-debug \
		-nostdlib \
		-ffreestanding \
		-o picoapp.elf \
		start.s \
		hal.c \
		simpleserial.c \
		memcpy.c memset.c \
		locality_ref.S \
		main_locality_ref.c \
		$(LDFLAGS)
	$(CROSSSIZE) picoapp.elf

picoapp.s: picoapp.elf
	$(CROSSOBJDUMP) --disassemble picoapp.elf > picoapp.s

picoapp.bin: picoapp.elf
	$(CROSSOBJCOPY) -O binary picoapp.elf picoapp.bin

firmware.bin: picoboot.bin picoapp.bin
	cat $^ > $@

clean:
	rm -f picoapp.elf picoapp.s picoboot.elf picochip.elf picoboot.bin picoboot.ubin picoapp.bin picoboot.s firmware.bin picochip.layout sections.lds picochip_fw* *~ locality_ref.s *.i *.o picoapp.*.s

#----------------------------------------
# flash chip programming

writeflash: firmware.bin clockconf
	@rm -f picochip.layout
	@touch picochip.layout
	@echo "00000000:000fffff start" >> picochip.layout
	@echo "00100000:001fffff program" >> picochip.layout
	@echo "00200000:00ffffff remainder" >> picochip.layout
	@truncate -s 1M zeros.bin
	@cat zeros.bin firmware.bin > concat.bin
	@truncate -s 16M concat.bin
	@rm zeros.bin
	flashrom -p ft2232_spi:type=4232H,port=A --layout picochip.layout --image program --write concat.bin
	@rm concat.bin

ifeq ($(CLOCK_FREQ), 1)
   CLOCKSETTINGS=../clockconf/cdce925_1mhz.txt
endif

ifeq ($(CLOCK_FREQ), 4)
   CLOCKSETTINGS=../clockconf/cdce925_4mhz.txt
endif

ifeq ($(CLOCK_FREQ), 8)
   CLOCKSETTINGS=../clockconf/cdce925_8mhz.txt
endif

ifeq ($(CLOCK_FREQ), 10)
   CLOCKSETTINGS=../clockconf/cdce925_10mhz.txt
endif

ifeq ($(CLOCK_FREQ), 16)
   CLOCKSETTINGS=../clockconf/cdce925_16mhz.txt
endif

ifeq ($(CLOCK_FREQ), 40)
   CLOCKSETTINGS=../clockconf/cdce925_40mhz.txt
endif

clockconf:
	sudo ../clockconf/clockconf $(CLOCKSETTINGS)
