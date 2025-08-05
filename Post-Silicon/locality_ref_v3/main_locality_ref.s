	.file	"main_locality_ref.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	get_and_inputs
	.type	get_and_inputs, @function
get_and_inputs:
	li	a5,11
	bgtu	a1,a5,.L9
	li	a0,1
	ret
.L9:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	sw	s2,16(sp)
	lbu	a6,1(a0)
	lbu	s0,0(a0)
	lbu	s1,4(a0)
	lbu	a3,5(a0)
	lbu	s2,8(a0)
	lbu	a4,9(a0)
	lbu	t3,3(a0)
	lbu	a5,2(a0)
	lbu	t1,7(a0)
	lbu	a7,11(a0)
	lbu	a1,6(a0)
	lbu	a2,10(a0)
	slli	a3,a3,16
	slli	a0,a6,16
	slli	a4,a4,16
	slli	s0,s0,24
	slli	s1,s1,24
	slli	s2,s2,24
	or	s1,s1,a3
	or	s2,s2,a4
	or	s0,s0,a0
	or	s0,s0,t3
	slli	a0,a5,8
	or	s1,s1,t1
	or	s2,s2,a7
	slli	a1,a1,8
	slli	a2,a2,8
	or	s0,s0,a0
	or	s1,s1,a1
	or	s2,s2,a2
	call	trigger_high
	mv	a1,s1
	mv	a0,s0
	mv	a2,s2
	call	locality_refresh
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
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	li	a0,0
	addi	sp,sp,32
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
	li	a1,12
	li	a0,112
	call	simpleserial_addcmd
.L11:
	call	simpleserial_get
	j	.L11
	.size	main, .-main
	.ident	"GCC: () 10.2.0"
