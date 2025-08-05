# 1 "simpleserial.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "simpleserial.c"


# 1 "simpleserial.h" 1






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
# 8 "simpleserial.h" 2
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
# 4 "simpleserial.c" 2

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
# 6 "simpleserial.c" 2



static int num_commands = 0;
# 20 "simpleserial.c"
uint8_t ss_crc(uint8_t *buf, uint8_t len)
{
 unsigned int k = 0;
 uint8_t crc = 0x00;
 while (len--) {
  crc ^= *buf++;
  for (k = 0; k < 8; k++) {
   crc = crc & 0x80 ? (crc << 1) ^ 0x4D: crc << 1;
  }
 }
 return crc;

}
# 251 "simpleserial.c"
typedef struct ss_cmd
{
 char c;
 unsigned int len;
 uint8_t (*fp)(uint8_t*, uint8_t);
 uint8_t flags;
} ss_cmd;
static ss_cmd commands[16];


uint8_t check_version(uint8_t *v, uint8_t len)
{
 return 1;
}

uint8_t ss_num_commands(uint8_t *x, uint8_t len)
{
    uint8_t ncmds = num_commands & 0xFF;
    simpleserial_put('r', 0x01, &ncmds);
    return 0x00;
}

typedef struct ss_cmd_repr {
    uint8_t c;
    uint8_t len;
    uint8_t flags;
} ss_cmd_repr;

uint8_t ss_get_commands(uint8_t *x, uint8_t len)
{
    ss_cmd_repr repr_cmd_buf[16];
    for (uint8_t i = 0; i < (num_commands & 0xFF); i++) {
        repr_cmd_buf[i].c = commands[i].c;
        repr_cmd_buf[i].len = commands[i].len;
        repr_cmd_buf[i].flags = commands[i].flags;
    }

    simpleserial_put('r', num_commands * 0x03, (void *) repr_cmd_buf);
    return 0x00;
}

static char hex_lookup[16] =
{
 '0', '1', '2', '3', '4', '5', '6', '7',
 '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
};

int hex_decode(int len, char* ascii_buf, uint8_t* data_buf)
{
 for(int i = 0; i < len; i++)
 {
  char n_hi = ascii_buf[2*i];
  char n_lo = ascii_buf[2*i+1];

  if(n_lo >= '0' && n_lo <= '9')
   data_buf[i] = n_lo - '0';
  else if(n_lo >= 'A' && n_lo <= 'F')
   data_buf[i] = n_lo - 'A' + 10;
  else if(n_lo >= 'a' && n_lo <= 'f')
   data_buf[i] = n_lo - 'a' + 10;
  else
   return 1;

  if(n_hi >= '0' && n_hi <= '9')
   data_buf[i] |= (n_hi - '0') << 4;
  else if(n_hi >= 'A' && n_hi <= 'F')
   data_buf[i] |= (n_hi - 'A' + 10) << 4;
  else if(n_hi >= 'a' && n_hi <= 'f')
   data_buf[i] |= (n_hi - 'a' + 10) << 4;
  else
   return 1;
 }

 return 0;
}





void simpleserial_init()
{
 simpleserial_addcmd('v', 0, check_version);
    simpleserial_addcmd('w', 0, ss_get_commands);
    simpleserial_addcmd('y', 0, ss_num_commands);
}

int simpleserial_addcmd(char c, unsigned int len, uint8_t (*fp)(uint8_t*, uint8_t))
{
 return simpleserial_addcmd_flags(c, len, fp, 0x00);
}

int simpleserial_addcmd_flags(char c, unsigned int len, uint8_t (*fp)(uint8_t*, uint8_t), uint8_t fl)
{
 if(num_commands >= 16)
  return 1;

 if(len >= 256)
  return 1;

 commands[num_commands].c = c;
 commands[num_commands].len = len;
 commands[num_commands].fp = fp;
 commands[num_commands].flags = fl;
 num_commands++;

 return 0;
}

void simpleserial_get(void)
{
 char ascii_buf[2*256];
 uint8_t data_buf[256];
 char c;


 c = getch();

 int cmd;
 for(cmd = 0; cmd < num_commands; cmd++)
 {
  if(commands[cmd].c == c)
   break;
 }


 if(cmd == num_commands)
  return;


 if ((commands[cmd].flags & 0x01) != 0)
 {
  uint8_t l = 0;
  char buff[2];
  buff[0] = getch();
  buff[1] = getch();
  if (hex_decode(1, buff, &l))
   return;
  commands[cmd].len = l;
 }


 for(int i = 0; i < 2*commands[cmd].len; i++)
 {
  c = getch();


  if(c == '\n' || c == '\r')
   return;

  ascii_buf[i] = c;
 }


 c = getch();
 if(c != '\n' && c != '\r')
  return;



 if(hex_decode(commands[cmd].len, ascii_buf, data_buf))
  return;


 uint8_t ret[1];
 ret[0] = commands[cmd].fp(data_buf, commands[cmd].len);



 simpleserial_put('z', 1, ret);

}

void simpleserial_put(char c, uint8_t size, uint8_t* output)
{

 putch(c);


 for(int i = 0; i < size; i++)
 {
  putch(hex_lookup[output[i] >> 4 ]);
  putch(hex_lookup[output[i] & 0xF]);
 }


 putch('\n');
}
