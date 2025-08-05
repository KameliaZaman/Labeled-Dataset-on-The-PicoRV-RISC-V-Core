# 1 "locality_ref.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "locality_ref.S"
.section .text
.global locality_refresh
locality_refresh:
    # Inputs:
    # a0 = A0 (first share)
    # a1 = A1 (second share)
    # a2 = r (random mask)

    mv t0, a0 # t0 = A0
    mv t1, a1 # t1 = A1
    mv t2, a2 # t2 = r

    xor t0, t0, t2 # t0 = A0 ^ r
    xor t1, t1, t2 # t1 = A1 ^ r

    mv a0, t0 # a0 = refreshed A0
    mv a1, t1 # a1 = refreshed A1

    ret
