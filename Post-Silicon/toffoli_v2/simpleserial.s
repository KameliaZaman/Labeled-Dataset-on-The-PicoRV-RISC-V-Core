	.file	"simpleserial.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	check_version
	.type	check_version, @function
check_version:
	li	a0,1
	ret
	.size	check_version, .-check_version
	.align	2
	.globl	ss_num_commands
	.type	ss_num_commands, @function
ss_num_commands:
	addi	sp,sp,-16
	lui	a5,%hi(num_commands)
	sw	s1,4(sp)
	lbu	s1,%lo(num_commands)(a5)
	li	a0,114
	sw	ra,12(sp)
	sw	s0,8(sp)
	call	putch
	lui	s0,%hi(.LANCHOR0)
	addi	s0,s0,%lo(.LANCHOR0)
	srli	a5,s1,4
	add	a5,s0,a5
	lbu	a0,0(a5)
	andi	s1,s1,15
	add	s0,s0,s1
	call	putch
	lbu	a0,0(s0)
	call	putch
	li	a0,10
	call	putch
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
	.size	ss_num_commands, .-ss_num_commands
	.align	2
	.globl	ss_crc
	.type	ss_crc, @function
ss_crc:
	mv	a2,a0
	beq	a1,zero,.L11
	add	a1,a0,a1
	li	a0,0
.L10:
	lbu	a5,0(a2)
	li	a4,8
	addi	a2,a2,1
	xor	a0,a0,a5
.L9:
	slli	a5,a0,1
	slli	a3,a0,24
	srai	a3,a3,24
	mv	a0,a5
	andi	a0,a0,0xff
	xori	a5,a5,77
	bge	a3,zero,.L8
	andi	a0,a5,0xff
.L8:
	addi	a4,a4,-1
	bne	a4,zero,.L9
	bne	a2,a1,.L10
	ret
.L11:
	li	a0,0
	ret
	.size	ss_crc, .-ss_crc
	.align	2
	.globl	hex_decode
	.type	hex_decode, @function
hex_decode:
	ble	a0,zero,.L15
	add	a7,a2,a0
	li	a6,5
	li	a0,9
	j	.L25
.L27:
	sb	a4,0(a2)
.L17:
	addi	a4,a5,-48
	andi	a3,a4,0xff
	bgtu	a3,a0,.L21
.L28:
	lbu	a5,0(a2)
	slli	a4,a4,4
	or	a4,a4,a5
	sb	a4,0(a2)
.L22:
	addi	a2,a2,1
	addi	a1,a1,2
	beq	a2,a7,.L15
.L25:
	lbu	a3,1(a1)
	lbu	a5,0(a1)
	addi	a4,a3,-48
	andi	a4,a4,0xff
	bleu	a4,a0,.L27
	addi	a4,a3,-65
	andi	a4,a4,0xff
	bgtu	a4,a6,.L18
	addi	a3,a3,-55
	addi	a4,a5,-48
	sb	a3,0(a2)
	andi	a3,a4,0xff
	bleu	a3,a0,.L28
.L21:
	addi	a4,a5,-65
	andi	a4,a4,0xff
	bgtu	a4,a6,.L23
	lbu	a4,0(a2)
	addi	a5,a5,-55
	slli	a5,a5,4
	or	a5,a5,a4
	sb	a5,0(a2)
	addi	a2,a2,1
	addi	a1,a1,2
	bne	a2,a7,.L25
.L15:
	li	a0,0
	ret
.L18:
	addi	a4,a3,-97
	andi	a4,a4,0xff
	bgtu	a4,a6,.L24
	addi	a3,a3,-87
	sb	a3,0(a2)
	j	.L17
.L23:
	addi	a4,a5,-97
	andi	a4,a4,0xff
	bgtu	a4,a6,.L24
	lbu	a4,0(a2)
	addi	a5,a5,-87
	slli	a5,a5,4
	or	a5,a5,a4
	sb	a5,0(a2)
	j	.L22
.L24:
	li	a0,1
	ret
	.size	hex_decode, .-hex_decode
	.align	2
	.globl	simpleserial_init
	.type	simpleserial_init, @function
simpleserial_init:
	lui	a1,%hi(num_commands)
	lw	a3,%lo(num_commands)(a1)
	li	a5,15
	bgt	a3,a5,.L29
	lui	a5,%hi(.LANCHOR1)
	addi	a5,a5,%lo(.LANCHOR1)
	slli	a2,a3,4
	add	a2,a5,a2
	li	a0,118
	sb	a0,0(a2)
	lui	a0,%hi(check_version)
	addi	a4,a3,1
	addi	a0,a0,%lo(check_version)
	sw	zero,4(a2)
	sw	a0,8(a2)
	sb	zero,12(a2)
	sw	a4,%lo(num_commands)(a1)
	li	a6,16
	beq	a4,a6,.L29
	slli	a4,a4,4
	add	a4,a5,a4
	li	a0,119
	sb	a0,0(a4)
	lui	a0,%hi(ss_get_commands)
	addi	a2,a3,2
	addi	a0,a0,%lo(ss_get_commands)
	sw	zero,4(a4)
	sw	a0,8(a4)
	sb	zero,12(a4)
	sw	a2,%lo(num_commands)(a1)
	beq	a2,a6,.L29
	slli	a2,a2,4
	add	a5,a5,a2
	li	a4,121
	sb	a4,0(a5)
	lui	a4,%hi(ss_num_commands)
	addi	a3,a3,3
	addi	a4,a4,%lo(ss_num_commands)
	sw	zero,4(a5)
	sw	a4,8(a5)
	sb	zero,12(a5)
	sw	a3,%lo(num_commands)(a1)
.L29:
	ret
	.size	simpleserial_init, .-simpleserial_init
	.align	2
	.globl	simpleserial_addcmd
	.type	simpleserial_addcmd, @function
simpleserial_addcmd:
	lui	a6,%hi(num_commands)
	lw	a4,%lo(num_commands)(a6)
	li	a5,15
	mv	a3,a0
	bgt	a4,a5,.L35
	li	a5,255
	li	a0,1
	bgtu	a1,a5,.L33
	lui	a5,%hi(.LANCHOR1)
	slli	a0,a4,4
	addi	a5,a5,%lo(.LANCHOR1)
	add	a5,a5,a0
	addi	a4,a4,1
	sb	a3,0(a5)
	sw	a1,4(a5)
	sw	a2,8(a5)
	sb	zero,12(a5)
	sw	a4,%lo(num_commands)(a6)
	li	a0,0
	ret
.L35:
	li	a0,1
.L33:
	ret
	.size	simpleserial_addcmd, .-simpleserial_addcmd
	.align	2
	.globl	simpleserial_addcmd_flags
	.type	simpleserial_addcmd_flags, @function
simpleserial_addcmd_flags:
	lui	a7,%hi(num_commands)
	lw	a4,%lo(num_commands)(a7)
	li	a5,15
	mv	a6,a0
	bgt	a4,a5,.L39
	li	a5,255
	li	a0,1
	bgtu	a1,a5,.L37
	lui	a5,%hi(.LANCHOR1)
	slli	a0,a4,4
	addi	a5,a5,%lo(.LANCHOR1)
	add	a5,a5,a0
	addi	a4,a4,1
	sb	a6,0(a5)
	sw	a1,4(a5)
	sw	a2,8(a5)
	sb	a3,12(a5)
	sw	a4,%lo(num_commands)(a7)
	li	a0,0
	ret
.L39:
	li	a0,1
.L37:
	ret
	.size	simpleserial_addcmd_flags, .-simpleserial_addcmd_flags
	.align	2
	.globl	simpleserial_get
	.type	simpleserial_get, @function
simpleserial_get:
	addi	sp,sp,-800
	sw	ra,796(sp)
	sw	s0,792(sp)
	sw	s1,788(sp)
	sw	s2,784(sp)
	sw	s3,780(sp)
	sw	s4,776(sp)
	sw	s5,772(sp)
	sw	s6,768(sp)
	call	getch
	lui	a5,%hi(num_commands)
	lw	a2,%lo(num_commands)(a5)
	ble	a2,zero,.L42
	lui	a5,%hi(.LANCHOR1)
	addi	s3,a5,%lo(.LANCHOR1)
	li	a4,0
	addi	a5,a5,%lo(.LANCHOR1)
	j	.L44
.L63:
	addi	a4,a4,1
	beq	a4,a2,.L41
.L44:
	lbu	a3,0(a5)
	addi	a5,a5,16
	bne	a3,a0,.L63
	slli	s0,a4,4
	add	s1,s3,s0
	lbu	a5,12(s1)
	andi	a5,a5,1
	bne	a5,zero,.L46
.L65:
	lw	a5,4(s1)
.L47:
	slli	a5,a5,1
	addi	s2,sp,256
	li	s1,0
	li	s4,10
	li	s5,13
	add	s6,s3,s0
	bne	a5,zero,.L53
	j	.L54
.L64:
	beq	a0,s5,.L41
	lw	a5,4(s6)
	sb	a0,0(s2)
	addi	s2,s2,1
	slli	a5,a5,1
	bleu	a5,s1,.L54
.L53:
	call	getch
	addi	s1,s1,1
	bne	a0,s4,.L64
.L41:
	lw	ra,796(sp)
	lw	s0,792(sp)
	lw	s1,788(sp)
	lw	s2,784(sp)
	lw	s3,780(sp)
	lw	s4,776(sp)
	lw	s5,772(sp)
	lw	s6,768(sp)
	addi	sp,sp,800
	jr	ra
.L42:
	beq	a2,zero,.L41
	lui	a5,%hi(.LANCHOR1)
	li	a4,0
	addi	s3,a5,%lo(.LANCHOR1)
	slli	s0,a4,4
	add	s1,s3,s0
	lbu	a5,12(s1)
	andi	a5,a5,1
	beq	a5,zero,.L65
.L46:
	sb	zero,0(sp)
	call	getch
	sb	a0,256(sp)
	call	getch
	mv	a5,a0
	mv	a2,sp
	addi	a1,sp,256
	li	a0,1
	sb	a5,257(sp)
	call	hex_decode
	bne	a0,zero,.L41
	lbu	a5,0(sp)
	sw	a5,4(s1)
	j	.L47
.L54:
	call	getch
	li	a5,10
	beq	a0,a5,.L52
	li	a5,13
	bne	a0,a5,.L41
.L52:
	add	s0,s3,s0
	lw	s1,4(s0)
	mv	a2,sp
	addi	a1,sp,256
	mv	a0,s1
	call	hex_decode
	bne	a0,zero,.L41
	lw	a5,8(s0)
	andi	a1,s1,0xff
	mv	a0,sp
	jalr	a5
	mv	s1,a0
	li	a0,122
	call	putch
	srli	a5,s1,4
	lui	s0,%hi(.LANCHOR0)
	addi	s0,s0,%lo(.LANCHOR0)
	andi	a5,a5,0xff
	add	a5,s0,a5
	lbu	a0,0(a5)
	andi	s1,s1,15
	add	s0,s0,s1
	call	putch
	lbu	a0,0(s0)
	call	putch
	li	a0,10
	call	putch
	j	.L41
	.size	simpleserial_get, .-simpleserial_get
	.align	2
	.globl	simpleserial_put
	.type	simpleserial_put, @function
simpleserial_put:
	addi	sp,sp,-16
	sw	s2,0(sp)
	mv	s2,a1
	sw	s0,8(sp)
	sw	ra,12(sp)
	sw	s1,4(sp)
	mv	s0,a2
	call	putch
	beq	s2,zero,.L67
	lui	s1,%hi(.LANCHOR0)
	add	s2,s0,s2
	addi	s1,s1,%lo(.LANCHOR0)
.L68:
	lbu	a5,0(s0)
	addi	s0,s0,1
	srli	a5,a5,4
	add	a5,s1,a5
	lbu	a0,0(a5)
	call	putch
	lbu	a5,-1(s0)
	andi	a5,a5,15
	add	a5,s1,a5
	lbu	a0,0(a5)
	call	putch
	bne	s2,s0,.L68
.L67:
	lw	s0,8(sp)
	lw	ra,12(sp)
	lw	s1,4(sp)
	lw	s2,0(sp)
	li	a0,10
	addi	sp,sp,16
	tail	putch
	.size	simpleserial_put, .-simpleserial_put
	.align	2
	.globl	ss_get_commands
	.type	ss_get_commands, @function
ss_get_commands:
	lui	a5,%hi(num_commands)
	lw	t1,%lo(num_commands)(a5)
	addi	sp,sp,-64
	sw	ra,60(sp)
	andi	a7,t1,255
	beq	a7,zero,.L75
	lui	a6,%hi(.LANCHOR1)
	li	a4,0
	li	a2,0
	addi	a6,a6,%lo(.LANCHOR1)
.L76:
	slli	a3,a2,4
	add	a3,a6,a3
	lbu	a0,0(a3)
	lw	a1,4(a3)
	slli	a5,a2,1
	lbu	a3,12(a3)
	add	a5,a5,a2
	addi	a2,sp,48
	add	a5,a2,a5
	addi	a4,a4,1
	andi	a4,a4,0xff
	sb	a0,-48(a5)
	sb	a1,-47(a5)
	sb	a3,-46(a5)
	mv	a2,a4
	blt	a4,a7,.L76
.L75:
	slli	a1,t1,1
	add	a1,t1,a1
	li	a0,114
	mv	a2,sp
	andi	a1,a1,0xff
	call	simpleserial_put
	lw	ra,60(sp)
	li	a0,0
	addi	sp,sp,64
	jr	ra
	.size	ss_get_commands, .-ss_get_commands
	.section	.rodata
	.align	2
	.set	.LANCHOR0,. + 0
	.type	hex_lookup, @object
	.size	hex_lookup, 16
hex_lookup:
	.ascii	"0123456789ABCDEF"
	.bss
	.align	2
	.set	.LANCHOR1,. + 0
	.type	commands, @object
	.size	commands, 256
commands:
	.zero	256
	.section	.sbss,"aw",@nobits
	.align	2
	.type	num_commands, @object
	.size	num_commands, 4
num_commands:
	.zero	4
	.ident	"GCC: () 10.2.0"
