# 1 "locality_ref.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "locality_ref.S"
.section .text
.global locality_refresh
# Mixes register use
locality_refresh:
    # a0 = A0, a1 = A1, a2 = r

    xor t0, a0, a2 # t0 = A0 ^ r
    xor a1, a1, a2 # a1 = A1 ^ r
    mv a0, t0 # a0 = refreshed A0

    ret
