# 1 "main_isw_and.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "main_isw_and.c"
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
# 2 "main_isw_and.c" 2
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
# 3 "main_isw_and.c" 2
# 1 "simpleserial.h" 1
# 21 "simpleserial.h"
void simpleserial_init(void);
# 48 "simpleserial.h"
int simpleserial_addcmd_flags(char c, unsigned int len, uint8_t (*fp)(uint8_t*, uint8_t), uint8_t);
int simpleserial_addcmd(char c, unsigned int len, uint8_t (*fp)(uint8_t*, uint8_t));
# 58 "simpleserial.h"
void simpleserial_get(void);




void simpleserial_put(char c, uint8_t size, uint8_t* output);

typedef enum ss_err_cmd {
 SS_ERR_OK,
 SS_ERR_CMD,
 SS_ERR_CRC,
 SS_ERR_TIMEOUT,
    SS_ERR_LEN,
    SS_ERR_FRAME_BYTE
} ss_err_cmd;
# 4 "main_isw_and.c" 2


extern void isw_and(uint32_t A0, uint32_t A1, uint32_t B0, uint32_t B1, uint32_t R);


uint8_t get_and_inputs(uint8_t *input, uint8_t len) {
    if (len < 20) return 0x01;


    uint32_t A0 = (input[0] << 24) | (input[1] << 16) | (input[2] << 8) | input[3];
    uint32_t A1 = (input[4] << 24) | (input[5] << 16) | (input[6] << 8) | input[7];
    uint32_t B0 = (input[8] << 24) | (input[9] << 16) | (input[10] << 8) | input[11];
    uint32_t B1 = (input[12] << 24) | (input[13] << 16) | (input[14] << 8) | input[15];
    uint32_t R = (input[16] << 24) | (input[17] << 16) | (input[18] << 8) | input[19];


    trigger_high();


    isw_and(A0, A1, B0, B1, R);


    trigger_low();






    register uint32_t C0 asm("a0");
    register uint32_t C1 asm("a1");


    uint8_t output[8];
    output[0] = (C0 >> 24) & 0xFF;
    output[1] = (C0 >> 16) & 0xFF;
    output[2] = (C0 >> 8) & 0xFF;
    output[3] = C0 & 0xFF;

    output[4] = (C1 >> 24) & 0xFF;
    output[5] = (C1 >> 16) & 0xFF;
    output[6] = (C1 >> 8) & 0xFF;
    output[7] = C1 & 0xFF;


    simpleserial_put('r', 8, output);
    return 0x00;
}

int main() {
    platform_init();

    simpleserial_init();
    simpleserial_addcmd('p', 20, get_and_inputs);

    while (1)
        simpleserial_get();

    return 0;
}
