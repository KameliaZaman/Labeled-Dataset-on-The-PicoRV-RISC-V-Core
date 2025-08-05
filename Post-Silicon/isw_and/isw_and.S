# 1 "isw_and.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "isw_and.S"
.section .text
.global isw_and
isw_and:
    # Inputs:
    # a0 = A0, a1 = A1
    # a2 = B0, a3 = B1
    # a4 = r

    mv t0, a0 # A0
    mv t1, a1 # A1
    mv t2, a2 # B0
    mv t3, a3 # B1
    mv t4, a4 # r

    # Compute partial products
    and t5, t0, t2 # t5 = A0 & B0
    and t6, t1, t3 # t6 = A1 & B1

    # Cross terms
    and t0, t0, t3 # t0 = A0 & B1 (reuse t0)
    and t1, t1, t2 # t1 = A1 & B0 (reuse t1)

    xor t0, t0, t1 # t0 = A0&B1 ^ A1&B0
    xor t0, t0, t4 # t0 = t0 ^ r

    xor t5, t5, t4 # C0 = A0&B0 ^ r
    xor t6, t6, t0 # C1 = A1&B1 ^ cross ^ r

    mv a0, t5 # Return C0
    mv a1, t6 # Return C1

    ret
