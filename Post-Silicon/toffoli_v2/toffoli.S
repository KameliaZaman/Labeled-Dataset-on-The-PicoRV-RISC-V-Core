# 1 "toffoli.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "toffoli.S"
.section .text
.global toffoli_gate

# Variation 2: Different Temporary Registers
toffoli_gate:
    and x17, x10, x11
    xor x12, x12, x17
    slli x10, x10, 2
    slli x14, x14, 2
    and x17, x10, x14
    srli x10, x10, 2
    srli x14, x14, 2
    slli x12, x12, 2
    xor x12, x12, x17
    srli x12, x12, 2
    and x17, x13, x14
    xor x15, x15, x17
    slli x13, x13, 2
    slli x11, x11, 2
    and x17, x13, x11
    srli x13, x13, 2
    srli x11, x11, 2
    slli x15, x15, 2
    xor x15, x15, x17
    srli x15, x15, 2
    xor x17, x17, x17
    mv x10, x15
    ret
