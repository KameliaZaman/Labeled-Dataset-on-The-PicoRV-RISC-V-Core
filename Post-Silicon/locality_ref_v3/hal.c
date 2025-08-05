#include <stdint.h>

#include "hal.h"

#define TRIGGERBIT 5

void platform_init() {
    set_flash_qspi_flag();

//    reg_uart_clkdiv = 104;          // 4 MHz clock => 38400 baud
    reg_uart_clkdiv = 130;          // 5 MHz clock => 38400 baud
//    reg_uart_clkdiv = 208;          // 8 MHz clock => 38400 baud

    // define GPIO as output
    reg_gpioctrl[0] = 1;
    reg_gpioctrl[1] = 1;
    reg_gpioctrl[2] = 1;
    reg_gpioctrl[3] = 1;
    reg_gpioctrl[4] = 1;
    reg_gpioctrl[5] = 1;
    reg_gpioctrl[6] = 1;
    reg_gpioctrl[7] = 1;
}

void ledon(uint8_t v) {
    reg_gpioctrl[v] = 1;
    reg_gpio[v] = 1;
}

void ledoff(uint8_t v) {
    reg_gpioctrl[v] = 1;
    reg_gpio[v] = 0;
}

char getch() {
    int32_t c = -1;
    while (c == -1) {
        c = reg_uart_data;
    }
    return (char) c;
}

void putch(char c) {
    //  if (c == '\n')
    //  putch('\r');
    reg_uart_data = c;
}

void trigger_high() {
    reg_gpio[TRIGGERBIT] = 1;
}

void trigger_low() {
    reg_gpio[TRIGGERBIT] = 0;
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

    // Read Configuration Registers (RDCR1 35h)
    buffer[0] = 0x35;
    buffer[1] = 0x00; // rdata
    flashio(buffer, 2, 0);
    uint8_t sr2 = buffer[1];

    // Write Enable Volatile (50h) + Write Status Register 2 (31h)
    buffer[0] = 0x31;
    buffer[1] = sr2 | 2; // Enable QSPI
    flashio(buffer, 2, 0x50);
}

void set_flash_mode_spi() {
    reg_spictrl = (reg_spictrl & ~0x007f0000) | 0x00000000;
}

void set_flash_mode_dual() {
    reg_spictrl = (reg_spictrl & ~0x007f0000) | 0x00400000;
}

void set_flash_mode_quad() {
    reg_spictrl = (reg_spictrl & ~0x007f0000) | 0x00240000;
}

void set_flash_mode_qddr() {
    reg_spictrl = (reg_spictrl & ~0x007f0000) | 0x00670000;
}

void enable_flash_crm() {
    reg_spictrl |= 0x00100000;
}

unsigned volatile int *muxro = (int *) 0x7000000; // 16 mux-based RO
unsigned volatile int *triro = (int *) 0x8000000; // 16 tristate-based RO

void configure_ro_max() {
    // configure all RO at max frequency
    int i;
    muxro[0] = 0x80000000; // enable bus control
    triro[0] = 0x80000000; // enable bus control
    for (i = 0; i < 12; i++)
        muxro[i] = 0;
    for (i = 0; i < 12; i++)
        triro[i] = 0;
}

void configure_ro_min() {
    int i;
    muxro[0] = 0x80000000; // enable bus control
    triro[0] = 0x80000000; // enable bus control
    for (i = 0; i < 12; i++)
        muxro[i] = 0x03030303;
    for (i = 0; i < 12; i++)
        triro[i] = 0x03030303;
}

#ifdef HIDING_ON
int romap[16] = {0x1 << 3,
                 0x3 << 3,
                 0x7 << 3,
                 0xF << 3,
                 0x1F << 3,
                 0x3F << 3,
                 0x7F << 3,
                 0xFF << 3,
                 0x1FF << 3,
                 0x3FF << 3,
                 0x7FF << 3,
                 0xFFF << 3,
                 0x1FFF << 3,
                 0x3FFF << 3,
                 0x7FFF << 3,
                 0xFFFF << 3
};
#else
int romap[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
#endif

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
