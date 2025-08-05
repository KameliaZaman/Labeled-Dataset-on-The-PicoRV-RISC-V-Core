#include <stdint.h>
#include "hal.h"
#include "simpleserial.h"

// Declare the Toffoli gate assembly function
extern void toffoli_gate(uint32_t a0, uint32_t b0, uint32_t c0,
                         uint32_t a1, uint32_t b1, uint32_t c1);

// Command handler to receive inputs and call the Toffoli gate function
    uint8_t get_inputs(uint8_t *input, uint8_t len) {
    uint32_t a0 = (input[0] << 24) | (input[1] << 16) | (input[2] << 8) | input[3];
    uint32_t b0 = (input[4] << 24) | (input[5] << 16) | (input[6] << 8) | input[7];
    uint32_t c0 = (input[8] << 24) | (input[9] << 16) | (input[10] << 8) | input[11];
    uint32_t a1 = (input[12] << 24) | (input[13] << 16) | (input[14] << 8) | input[15];
    uint32_t b1 = (input[16] << 24) | (input[17] << 16) | (input[18] << 8) | input[19];
    uint32_t c1 = (input[20] << 24) | (input[21] << 16) | (input[22] << 8) | input[23];

    // Indicate the start of processing
    trigger_high();
    
    toffoli_gate(a0, b0, c0, a1, b1, c1);
    
    trigger_low();

    // We'll assume the wrapper sets global variables or memory—alternatively:
    register uint32_t out1 asm("a0");
    register uint32_t out2 asm("a1");
    
    // Prepare the output    
    uint8_t output[8];
    output[0] = (out1 >> 24) & 0xFF;
    output[1] = (out1 >> 16) & 0xFF;
    output[2] = (out1 >> 8) & 0xFF;
    output[3] = out1 & 0xFF;

    output[4] = (out2 >> 24) & 0xFF;
    output[5] = (out2 >> 16) & 0xFF;
    output[6] = (out2 >> 8) & 0xFF;
    output[7] = out2 & 0xFF;

    simpleserial_put('r', 8, output);

    return 0x0;
}

// Main function to initialize the platform and handle commands
int main() {
    platform_init();
    simpleserial_init();

    // Register the 'p' command for processing inputs
    simpleserial_addcmd('p', 24, get_inputs);

    // Event loop
    while (1) {
        simpleserial_get();
    }

    return 0;
}

