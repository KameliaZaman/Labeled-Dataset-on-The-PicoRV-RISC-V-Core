# 1 "isw_and.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "isw_and.S"
.section .text
.global isw_and
# Use temporary storage in memory
isw_and:
    addi sp, sp, -16
    sw a0, 0(sp) # A0
    sw a1, 4(sp) # A1
    sw a2, 8(sp) # B0
    sw a3, 12(sp) # B1

    lw t0, 0(sp) # A0
    lw t1, 4(sp) # A1
    lw t2, 8(sp) # B0
    lw t3, 12(sp) # B1
    mv t4, a4 # r

    and t5, t0, t2 # A0 & B0
    and t6, t1, t3 # A1 & B1

    and t0, t0, t3 # A0 & B1
    and t1, t1, t2 # A1 & B0
    xor t0, t0, t1
    xor t0, t0, t4

    xor t5, t5, t4
    xor t6, t6, t0

    mv a0, t5
    mv a1, t6

    addi sp, sp, 16
    ret
