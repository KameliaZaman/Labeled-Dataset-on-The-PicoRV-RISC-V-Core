# 1 "toffoli.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "toffoli.S"
.section .text
.global toffoli_gate

# Toffoli gate implementation with one temporary register
# Input: a0, b0, c0, a1, b1, c1 stored in registers x10 - x15
# Temp register: x16 (R6)

toffoli_gate:
    # Step 0: Compute a0b0 -> R6 (x18)
    and x16, x10, x11

    # Step 1: Compute c0 + a0b0 -> R2 (x12)
    xor x12, x12, x16

    # Step 2: Compute shift R0 (x10)
    slli x10, x10, 2

    # Step 3: Compute shift R4 (x14)
    slli x14, x14, 2

    # Step 4: Compute a0b1 -> R6 (x18)
    and x16, x10, x14

    # Step 5: Compute shift back R0 (x10)
    srli x10, x10, 2

    # Step 6: Compute shift back R4 (x14)
    srli x14, x14, 2

    # Step 7: Compute shift R2 (x12)
    slli x12, x12, 2

    # Step 8: Compute c0 + a0b0 + a0b1 -> R2 (x12)
    xor x12, x12, x16

    # Step 9: Compute shift back R2 (x12)
    srli x12, x12, 2

    # Step 10: Compute a1b1 -> R6 (x16)
    and x16, x13, x14

    # Step 11: Compute a1b1 + c1 -> R5 (x15)
    xor x15, x15, x16

    # Step 12: Compute shift R3 (x13)
    slli x13, x13, 2

    # Step 13: Compute shift R1 (x11)
    slli x11, x11, 2

    # Step 14: Compute a1b0 -> R6 (x16)
    and x16, x13, x11

    # Step 15: Compute shift back R3 (x13)
    srli x13, x13, 2

    # Step 16: Compute shift back R1 (x11)
    srli x11, x11, 2

    # Step 17: Compute shift R5 (x15)
    slli x15, x15, 2

    # Step 18: Compute c1 + a1b1 + a1b0 -> R5 (x15)
    xor x15, x15, x16

    # Step 19: Compute shift back R5 (x15)
    srli x15, x15, 2

    # Step 20: Clear R6 (x16)
    xor x16, x16, x16

    mv x10, x15

    # Return
    ret
