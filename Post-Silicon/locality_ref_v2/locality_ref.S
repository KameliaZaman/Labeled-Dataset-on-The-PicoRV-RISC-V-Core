# 1 "locality_ref.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "locality_ref.S"
.section .text
.global locality_refresh
# Swap registers
locality_refresh:
    # a0 = A0, a1 = A1, a2 = r

    mv t3, a0
    mv t4, a1
    xor t3, t3, a2
    xor t4, t4, a2
    mv a0, t3
    mv a1, t4

    ret
