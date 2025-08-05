	.file	"main_isw_and.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	get_and_inputs
	.type	get_and_inputs, @function
get_and_inputs:
	li	a5,19
	bgtu	a1,a5,.L9
	li	a0,1
	ret
.L9:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	sw	s2,32(sp)
	sw	s3,28(sp)
	sw	s4,24(sp)
	lbu	ra,1(a0)
	lbu	s4,0(a0)
	lbu	s0,4(a0)
	lbu	t2,5(a0)
	lbu	s1,8(a0)
	lbu	t0,9(a0)
	lbu	s2,12(a0)
	lbu	t5,13(a0)
	lbu	s3,16(a0)
	lbu	t1,17(a0)
	lbu	t6,3(a0)
	lbu	a6,2(a0)
	lbu	t4,7(a0)
	lbu	t3,11(a0)
	lbu	a7,15(a0)
	lbu	a5,19(a0)
	lbu	a1,6(a0)
	lbu	a2,10(a0)
	lbu	a3,14(a0)
	lbu	a4,18(a0)
	slli	t2,t2,16
	slli	a0,ra,16
	slli	t0,t0,16
	slli	t5,t5,16
	slli	t1,t1,16
	slli	s4,s4,24
	slli	s0,s0,24
	slli	s1,s1,24
	slli	s2,s2,24
	slli	s3,s3,24
	or	s0,s0,t2
	or	s1,s1,t0
	or	s2,s2,t5
	or	s3,s3,t1
	or	s4,s4,a0
	or	s4,s4,t6
	slli	a0,a6,8
	or	s0,s0,t4
	or	s1,s1,t3
	or	s2,s2,a7
	or	s3,s3,a5
	slli	a1,a1,8
	slli	a2,a2,8
	slli	a3,a3,8
	slli	a4,a4,8
	or	s4,s4,a0
	or	s0,s0,a1
	or	s1,s1,a2
	or	s2,s2,a3
	or	s3,s3,a4
	call	trigger_high
	mv	a1,s0
	mv	a0,s4
	mv	a4,s3
	mv	a3,s2
	mv	a2,s1
	call	isw_and
	call	trigger_low
	mv	a4,a0
	mv	a5,a1
	srli	t4,a0,24
	srli	t3,a0,16
	srli	t1,a0,8
	srli	a7,a1,24
	srli	a6,a1,16
	srli	a3,a1,8
	addi	a2,sp,8
	li	a0,114
	li	a1,8
	sb	t4,8(sp)
	sb	t3,9(sp)
	sb	t1,10(sp)
	sb	a4,11(sp)
	sb	a7,12(sp)
	sb	a6,13(sp)
	sb	a3,14(sp)
	sb	a5,15(sp)
	call	simpleserial_put
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	li	a0,0
	addi	sp,sp,48
	jr	ra
	.size	get_and_inputs, .-get_and_inputs
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	platform_init
	call	simpleserial_init
	lui	a2,%hi(get_and_inputs)
	addi	a2,a2,%lo(get_and_inputs)
	li	a1,20
	li	a0,112
	call	simpleserial_addcmd
.L11:
	call	simpleserial_get
	j	.L11
	.size	main, .-main
	.ident	"GCC: () 10.2.0"
