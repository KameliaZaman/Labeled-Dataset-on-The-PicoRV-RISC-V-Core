	.file	"memset.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	memset
	.type	memset, @function
memset:
	andi	a1,a1,0xff
	add	a4,a0,a2
	mv	a5,a0
	beq	a2,zero,.L7
.L3:
	addi	a5,a5,1
	sb	a1,-1(a5)
	bne	a5,a4,.L3
.L7:
	ret
	.size	memset, .-memset
	.ident	"GCC: () 10.2.0"
