# 1 "hal.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "hal.c"
# 1 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h" 1
# 12 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h"
# 1 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h" 1







# 1 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/features.h" 1
# 28 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/features.h"
# 1 "/usr/lib/picolibc/riscv64-unknown-elf/include/picolibc.h" 1





       
# 29 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/features.h" 2
# 9 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h" 2
# 41 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef signed char __int8_t;

typedef unsigned char __uint8_t;
# 55 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef short int __int16_t;

typedef short unsigned int __uint16_t;
# 77 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef long int __int32_t;

typedef long unsigned int __uint32_t;
# 103 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef long long int __int64_t;

typedef long long unsigned int __uint64_t;
# 134 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef signed char __int_least8_t;

typedef unsigned char __uint_least8_t;
# 160 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef short int __int_least16_t;

typedef short unsigned int __uint_least16_t;
# 182 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef long int __int_least32_t;

typedef long unsigned int __uint_least32_t;
# 200 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef long long int __int_least64_t;

typedef long long unsigned int __uint_least64_t;
# 214 "/usr/lib/picolibc/riscv64-unknown-elf/include/machine/_default_types.h"
typedef long long int __intmax_t;







typedef long long unsigned int __uintmax_t;







typedef int __intptr_t;

typedef unsigned int __uintptr_t;
# 13 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h" 2
# 1 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/_intsup.h" 1
# 35 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/_intsup.h"
       
       
       
       
       
       
       
       
# 190 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/_intsup.h"
       
       
       
       
       
       
       
       
# 14 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h" 2
# 1 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/_stdint.h" 1
# 20 "/usr/lib/picolibc/riscv64-unknown-elf/include/sys/_stdint.h"
typedef __int8_t int8_t ;



typedef __uint8_t uint8_t ;







typedef __int16_t int16_t ;



typedef __uint16_t uint16_t ;







typedef __int32_t int32_t ;



typedef __uint32_t uint32_t ;







typedef __int64_t int64_t ;



typedef __uint64_t uint64_t ;






typedef __intmax_t intmax_t;




typedef __uintmax_t uintmax_t;




typedef __intptr_t intptr_t;




typedef __uintptr_t uintptr_t;
# 15 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h" 2






typedef __int_least8_t int_least8_t;
typedef __uint_least8_t uint_least8_t;




typedef __int_least16_t int_least16_t;
typedef __uint_least16_t uint_least16_t;




typedef __int_least32_t int_least32_t;
typedef __uint_least32_t uint_least32_t;




typedef __int_least64_t int_least64_t;
typedef __uint_least64_t uint_least64_t;
# 51 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h"
  typedef int int_fast8_t;
  typedef unsigned int uint_fast8_t;
# 61 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h"
  typedef int int_fast16_t;
  typedef unsigned int uint_fast16_t;
# 71 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h"
  typedef int int_fast32_t;
  typedef unsigned int uint_fast32_t;
# 81 "/usr/lib/picolibc/riscv64-unknown-elf/include/stdint.h"
  typedef long long int int_fast64_t;
  typedef long long unsigned int uint_fast64_t;
# 2 "hal.c" 2

# 1 "hal.h" 1
# 13 "hal.h"
char getch();

void putch(char c);

void trigger_high();

void trigger_low();

void platform_init();

void ledon(uint8_t v);

void ledoff(uint8_t v);

void set_flash_qspi_flag();

void set_flash_mode_spi();

void set_flash_mode_dual();

void set_flash_mode_quad();

void set_flash_mode_qddr();

void enable_flash_crm();

void configure_ro_max();

void configure_ro_min();

void enable_ro();

void enable_ro_config(uint8_t v);

void disable_ro();
# 4 "hal.c" 2



void platform_init() {
    set_flash_qspi_flag();


    (*(volatile uint32_t*)0x02000004) = 130;



    ( (volatile uint32_t*)0x03800000)[0] = 1;
    ( (volatile uint32_t*)0x03800000)[1] = 1;
    ( (volatile uint32_t*)0x03800000)[2] = 1;
    ( (volatile uint32_t*)0x03800000)[3] = 1;
    ( (volatile uint32_t*)0x03800000)[4] = 1;
    ( (volatile uint32_t*)0x03800000)[5] = 1;
    ( (volatile uint32_t*)0x03800000)[6] = 1;
    ( (volatile uint32_t*)0x03800000)[7] = 1;
}

void ledon(uint8_t v) {
    ( (volatile uint32_t*)0x03800000)[v] = 1;
    ( (volatile uint32_t*)0x03000000)[v] = 1;
}

void ledoff(uint8_t v) {
    ( (volatile uint32_t*)0x03800000)[v] = 1;
    ( (volatile uint32_t*)0x03000000)[v] = 0;
}

char getch() {
    int32_t c = -1;
    while (c == -1) {
        c = (*(volatile uint32_t*)0x02000008);
    }
    return (char) c;
}

void putch(char c) {


    (*(volatile uint32_t*)0x02000008) = c;
}

void trigger_high() {
    ( (volatile uint32_t*)0x03000000)[5] = 1;
}

void trigger_low() {
    ( (volatile uint32_t*)0x03000000)[5] = 0;
}

extern uint32_t flashio_worker_begin;
extern uint32_t flashio_worker_end;

void flashio(uint8_t *data, int len, uint8_t wrencmd) {
    uint32_t func[&flashio_worker_end - &flashio_worker_begin];

    uint32_t *src_ptr = &flashio_worker_begin;
    uint32_t *dst_ptr = func;

    while (src_ptr != &flashio_worker_end)
        *(dst_ptr++) = *(src_ptr++);

    ((void (*)(uint8_t *, uint32_t, uint32_t)) func)(data, len, wrencmd);
}

void set_flash_qspi_flag() {
    uint8_t buffer[8];


    buffer[0] = 0x35;
    buffer[1] = 0x00;
    flashio(buffer, 2, 0);
    uint8_t sr2 = buffer[1];


    buffer[0] = 0x31;
    buffer[1] = sr2 | 2;
    flashio(buffer, 2, 0x50);
}

void set_flash_mode_spi() {
    (*(volatile uint32_t*)0x02000000) = ((*(volatile uint32_t*)0x02000000) & ~0x007f0000) | 0x00000000;
}

void set_flash_mode_dual() {
    (*(volatile uint32_t*)0x02000000) = ((*(volatile uint32_t*)0x02000000) & ~0x007f0000) | 0x00400000;
}

void set_flash_mode_quad() {
    (*(volatile uint32_t*)0x02000000) = ((*(volatile uint32_t*)0x02000000) & ~0x007f0000) | 0x00240000;
}

void set_flash_mode_qddr() {
    (*(volatile uint32_t*)0x02000000) = ((*(volatile uint32_t*)0x02000000) & ~0x007f0000) | 0x00670000;
}

void enable_flash_crm() {
    (*(volatile uint32_t*)0x02000000) |= 0x00100000;
}

unsigned volatile int *muxro = (int *) 0x7000000;
unsigned volatile int *triro = (int *) 0x8000000;

void configure_ro_max() {

    int i;
    muxro[0] = 0x80000000;
    triro[0] = 0x80000000;
    for (i = 0; i < 12; i++)
        muxro[i] = 0;
    for (i = 0; i < 12; i++)
        triro[i] = 0;
}

void configure_ro_min() {
    int i;
    muxro[0] = 0x80000000;
    triro[0] = 0x80000000;
    for (i = 0; i < 12; i++)
        muxro[i] = 0x03030303;
    for (i = 0; i < 12; i++)
        triro[i] = 0x03030303;
}
# 150 "hal.c"
int romap[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


void enable_ro_config(uint8_t v) {
    uint8_t v1, v2;
    v1 = v & 0xf;
    v2 = (v >> 4) & 0xf;
    triro[0] = 0x80000000 + romap[v1];
    muxro[0] = 0x80000000 + romap[v2];
}

void enable_ro() {
    muxro[0] = 0x80000000 | (0xFFFF << 3);
    triro[0] = 0x80000000 | (0xFFFF << 3);
}

void disable_ro() {
    muxro[0] = 0x80000000;
    triro[0] = 0x80000000;
}
