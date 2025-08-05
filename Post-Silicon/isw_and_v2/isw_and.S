# 1 "isw_and.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "isw_and.S"
.section .text
.global isw_and
# Without masking
isw_and:
    mv t0, a0
    mv t1, a1
    mv t2, a2
    mv t3, a3
    mv t4, a4

    and t5, t0, t2 # A0 & B0
    and t6, t1, t3 # A1 & B1

    and t0, t0, t3 # A0 & B1
    and t1, t1, t2 # A1 & B0
    xor t0, t0, t1 # A0&B1 ^ A1&B0
    xor t0, t0, t4 # ^ r

    # ⚠️ Intentionally leave C0 unmasked
    # xor t5, t5, t4 # OMITTED

    xor t6, t6, t0 # C1

    mv a0, t5 # C0 = A0 & B0 (leaky!)
    mv a1, t6
    ret
