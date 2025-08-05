#include <stdint.h>
#include "hal.h"
#include "simpleserial.h"

// Declare the external RISC-V function
extern void locality_refresh(uint32_t A0, uint32_t A1, uint32_t R);

// SimpleSerial command handler
uint8_t get_and_inputs(uint8_t *input, uint8_t len) {
    if (len < 12) return 0x01; // Not enough bytes: 3 inputs × 4 bytes = 12 bytes

    // Extract 5 32-bit integers: A0, A1, B0, B1, R
    uint32_t A0 = (input[0] << 24) | (input[1] << 16) | (input[2] << 8) | input[3];
    uint32_t A1 = (input[4] << 24) | (input[5] << 16) | (input[6] << 8) | input[7];
    uint32_t R  = (input[8] << 24) | (input[9] << 16) | (input[10] << 8) | input[11];
    
    // Trigger high before starting
    trigger_high();

    // Call assembly function
    locality_refresh(A0, A1, R);

    // Trigger low after processing
    trigger_low();

    // Read the result back from a0, a1 (set by the assembly)
    // These must be captured as return values of a0 and a1
    // So the wrapper must write them back

    // We'll assume the wrapper sets global variables or memory—alternatively:
    register uint32_t C0 asm("a0");
    register uint32_t C1 asm("a1");

    // Pack output
    uint8_t output[8];
    output[0] = (C0 >> 24) & 0xFF;
    output[1] = (C0 >> 16) & 0xFF;
    output[2] = (C0 >> 8) & 0xFF;
    output[3] = C0 & 0xFF;

    output[4] = (C1 >> 24) & 0xFF;
    output[5] = (C1 >> 16) & 0xFF;
    output[6] = (C1 >> 8) & 0xFF;
    output[7] = C1 & 0xFF;

    // Send output via SimpleSerial
    simpleserial_put('r', 8, output);
    return 0x0;
}

int main() {
    platform_init();

    simpleserial_init();
    simpleserial_addcmd('p', 12, get_and_inputs); // 3 × 4B = 12 bytes input

    while (1)
        simpleserial_get();

    return 0;
}
