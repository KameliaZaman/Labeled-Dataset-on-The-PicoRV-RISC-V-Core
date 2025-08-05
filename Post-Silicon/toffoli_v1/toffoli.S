# 1 "toffoli.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "toffoli.S"
 .section .text
.global toffoli_gate

# Variation 1: Reordered Operations
# Input: a0, b0, c0, a1, b1, c1 stored in x10 - x15
# Temp register: x16 (R6)
toffoli_gate:
    and x16, x10, x11
    xor x12, x12, x16
    slli x14, x14, 2
    slli x10, x10, 2
    and x16, x10, x14
    srli x10, x10, 2
    srli x14, x14, 2
    slli x12, x12, 2
    xor x12, x12, x16
    srli x12, x12, 2
    and x16, x13, x14
    xor x15, x15, x16
    slli x13, x13, 2
    slli x11, x11, 2
    and x16, x13, x11
    srli x13, x13, 2
    srli x11, x11, 2
    slli x15, x15, 2
    xor x15, x15, x16
    srli x15, x15, 2
    xor x16, x16, x16
    mv x10, x15
    ret
