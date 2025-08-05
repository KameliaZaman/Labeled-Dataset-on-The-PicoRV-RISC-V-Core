	.file	"memcpy.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	memcpy
	.type	memcpy, @function
memcpy:
	beq	a2,zero,.L2
	add	a2,a0,a2
	mv	a5,a0
.L3:
	lbu	a4,0(a1)
	addi	a5,a5,1
	addi	a1,a1,1
	sb	a4,-1(a5)
	bne	a5,a2,.L3
.L2:
	ret
	.size	memcpy, .-memcpy
	.ident	"GCC: () 10.2.0"
