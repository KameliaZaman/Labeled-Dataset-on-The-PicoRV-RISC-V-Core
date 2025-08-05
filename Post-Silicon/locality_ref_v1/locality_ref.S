# 1 "locality_ref.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "locality_ref.S"
.section .text
.global locality_refresh
# Minimalist version
locality_refresh:
    # a0 = A0, a1 = A1, a2 = r

    xor a0, a0, a2 # A0' = A0 ^ r
    xor a1, a1, a2 # A1' = A1 ^ r

    ret
