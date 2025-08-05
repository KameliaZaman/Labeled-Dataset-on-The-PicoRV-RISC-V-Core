	.file	"hal.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	platform_init
	.type	platform_init, @function
platform_init:
	addi	sp,sp,-48
	sw	s2,32(sp)
	lui	a5,%hi(flashio_worker_begin)
	lui	s2,%hi(flashio_worker_end)
	sw	s1,36(sp)
	addi	s2,s2,%lo(flashio_worker_end)
	addi	s1,a5,%lo(flashio_worker_begin)
	sw	s3,28(sp)
	sub	s3,s2,s1
	addi	s3,s3,3
	andi	s3,s3,-4
	sw	s0,40(sp)
	sw	s4,24(sp)
	sw	ra,44(sp)
	addi	s0,sp,48
	addi	s3,s3,15
	andi	a4,s3,-16
	li	a3,53
	mv	s4,sp
	sb	a3,-40(s0)
	sub	sp,sp,a4
	sb	zero,-39(s0)
	mv	a6,sp
	beq	s1,s2,.L2
	mv	a4,a6
	addi	a5,a5,%lo(flashio_worker_begin)
.L3:
	lw	a3,0(a5)
	addi	a5,a5,4
	addi	a4,a4,4
	sw	a3,-4(a4)
	bne	a5,s2,.L3
.L2:
	li	a2,0
	li	a1,2
	addi	a0,s0,-40
	jalr	a6
	lbu	a5,-39(s0)
	mv	sp,s4
	andi	s3,s3,-16
	ori	a5,a5,2
	li	a4,49
	sub	sp,sp,s3
	sb	a4,-40(s0)
	sb	a5,-39(s0)
	mv	a6,sp
	beq	s1,s2,.L4
	mv	a4,a6
	mv	a5,s1
.L5:
	lw	a3,0(a5)
	addi	a5,a5,4
	addi	a4,a4,4
	sw	a3,-4(a4)
	bne	a5,s2,.L5
.L4:
	addi	a0,s0,-40
	li	a2,80
	li	a1,2
	jalr	a6
	li	a5,33554432
	li	a4,130
	sw	a4,4(a5)
	li	a5,58720256
	li	a4,1
	sw	a4,0(a5)
	sw	a4,4(a5)
	sw	a4,8(a5)
	sw	a4,12(a5)
	sw	a4,16(a5)
	sw	a4,20(a5)
	sw	a4,24(a5)
	sw	a4,28(a5)
	addi	sp,s0,-48
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	addi	sp,sp,48
	jr	ra
	.size	platform_init, .-platform_init
	.align	2
	.globl	ledon
	.type	ledon, @function
ledon:
	slli	a0,a0,2
	li	a5,58720256
	add	a5,a5,a0
	li	a4,1
	sw	a4,0(a5)
	li	a5,50331648
	add	a0,a5,a0
	sw	a4,0(a0)
	ret
	.size	ledon, .-ledon
	.align	2
	.globl	ledoff
	.type	ledoff, @function
ledoff:
	slli	a0,a0,2
	li	a5,58720256
	add	a5,a5,a0
	li	a4,1
	sw	a4,0(a5)
	li	a5,50331648
	add	a0,a5,a0
	sw	zero,0(a0)
	ret
	.size	ledoff, .-ledoff
	.align	2
	.globl	getch
	.type	getch, @function
getch:
	li	a4,33554432
	li	a5,-1
.L13:
	lw	a0,8(a4)
	beq	a0,a5,.L13
	andi	a0,a0,0xff
	ret
	.size	getch, .-getch
	.align	2
	.globl	putch
	.type	putch, @function
putch:
	li	a5,33554432
	sw	a0,8(a5)
	ret
	.size	putch, .-putch
	.align	2
	.globl	trigger_high
	.type	trigger_high, @function
trigger_high:
	li	a5,50331648
	li	a4,1
	sw	a4,20(a5)
	ret
	.size	trigger_high, .-trigger_high
	.align	2
	.globl	trigger_low
	.type	trigger_low, @function
trigger_low:
	li	a5,50331648
	sw	zero,20(a5)
	ret
	.size	trigger_low, .-trigger_low
	.align	2
	.globl	flashio
	.type	flashio, @function
flashio:
	lui	a5,%hi(flashio_worker_begin)
	lui	a6,%hi(flashio_worker_end)
	addi	a6,a6,%lo(flashio_worker_end)
	addi	a3,a5,%lo(flashio_worker_begin)
	sub	a4,a6,a3
	addi	a4,a4,3
	andi	a4,a4,-4
	addi	sp,sp,-16
	addi	a4,a4,15
	sw	s0,8(sp)
	sw	ra,12(sp)
	addi	s0,sp,16
	andi	a4,a4,-16
	sub	sp,sp,a4
	mv	a7,sp
	beq	a3,a6,.L19
	mv	a4,a7
	addi	a5,a5,%lo(flashio_worker_begin)
.L20:
	lw	a3,0(a5)
	addi	a5,a5,4
	addi	a4,a4,4
	sw	a3,-4(a4)
	bne	a5,a6,.L20
.L19:
	jalr	a7
	addi	sp,s0,-16
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	flashio, .-flashio
	.align	2
	.globl	set_flash_qspi_flag
	.type	set_flash_qspi_flag, @function
set_flash_qspi_flag:
	addi	sp,sp,-48
	sw	s2,32(sp)
	lui	a5,%hi(flashio_worker_begin)
	lui	s2,%hi(flashio_worker_end)
	sw	s1,36(sp)
	addi	s2,s2,%lo(flashio_worker_end)
	addi	s1,a5,%lo(flashio_worker_begin)
	sw	s3,28(sp)
	sub	s3,s2,s1
	addi	s3,s3,3
	andi	s3,s3,-4
	sw	s0,40(sp)
	sw	s4,24(sp)
	sw	ra,44(sp)
	addi	s0,sp,48
	addi	s3,s3,15
	andi	a4,s3,-16
	li	a3,53
	mv	s4,sp
	sb	a3,-40(s0)
	sub	sp,sp,a4
	sb	zero,-39(s0)
	mv	a6,sp
	beq	s1,s2,.L24
	mv	a4,a6
	addi	a5,a5,%lo(flashio_worker_begin)
.L25:
	lw	a3,0(a5)
	addi	a5,a5,4
	addi	a4,a4,4
	sw	a3,-4(a4)
	bne	a5,s2,.L25
.L24:
	li	a2,0
	li	a1,2
	addi	a0,s0,-40
	jalr	a6
	lbu	a5,-39(s0)
	mv	sp,s4
	andi	s3,s3,-16
	ori	a5,a5,2
	li	a4,49
	sub	sp,sp,s3
	sb	a4,-40(s0)
	sb	a5,-39(s0)
	mv	a6,sp
	beq	s1,s2,.L26
	mv	a4,a6
	mv	a5,s1
.L27:
	lw	a3,0(a5)
	addi	a5,a5,4
	addi	a4,a4,4
	sw	a3,-4(a4)
	bne	a5,s2,.L27
.L26:
	addi	a0,s0,-40
	li	a2,80
	li	a1,2
	jalr	a6
	addi	sp,s0,-48
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	addi	sp,sp,48
	jr	ra
	.size	set_flash_qspi_flag, .-set_flash_qspi_flag
	.align	2
	.globl	set_flash_mode_spi
	.type	set_flash_mode_spi, @function
set_flash_mode_spi:
	li	a3,33554432
	lw	a5,0(a3)
	li	a4,-8323072
	addi	a4,a4,-1
	and	a5,a5,a4
	sw	a5,0(a3)
	ret
	.size	set_flash_mode_spi, .-set_flash_mode_spi
	.align	2
	.globl	set_flash_mode_dual
	.type	set_flash_mode_dual, @function
set_flash_mode_dual:
	li	a3,33554432
	lw	a5,0(a3)
	li	a4,-8323072
	addi	a4,a4,-1
	and	a5,a5,a4
	li	a4,4194304
	or	a5,a5,a4
	sw	a5,0(a3)
	ret
	.size	set_flash_mode_dual, .-set_flash_mode_dual
	.align	2
	.globl	set_flash_mode_quad
	.type	set_flash_mode_quad, @function
set_flash_mode_quad:
	li	a3,33554432
	lw	a5,0(a3)
	li	a4,-8323072
	addi	a4,a4,-1
	and	a5,a5,a4
	li	a4,2359296
	or	a5,a5,a4
	sw	a5,0(a3)
	ret
	.size	set_flash_mode_quad, .-set_flash_mode_quad
	.align	2
	.globl	set_flash_mode_qddr
	.type	set_flash_mode_qddr, @function
set_flash_mode_qddr:
	li	a3,33554432
	lw	a5,0(a3)
	li	a4,-8323072
	addi	a4,a4,-1
	and	a5,a5,a4
	li	a4,6750208
	or	a5,a5,a4
	sw	a5,0(a3)
	ret
	.size	set_flash_mode_qddr, .-set_flash_mode_qddr
	.align	2
	.globl	enable_flash_crm
	.type	enable_flash_crm, @function
enable_flash_crm:
	li	a4,33554432
	lw	a5,0(a4)
	li	a3,1048576
	or	a5,a5,a3
	sw	a5,0(a4)
	ret
	.size	enable_flash_crm, .-enable_flash_crm
	.align	2
	.globl	configure_ro_max
	.type	configure_ro_max, @function
configure_ro_max:
	lui	a5,%hi(muxro)
	lw	a4,%lo(muxro)(a5)
	lui	a5,%hi(triro)
	lw	a5,%lo(triro)(a5)
	li	a3,-2147483648
	sw	a3,0(a4)
	sw	a3,0(a5)
	addi	a3,a4,48
.L37:
	sw	zero,0(a4)
	addi	a4,a4,4
	bne	a4,a3,.L37
	addi	a4,a5,48
.L38:
	sw	zero,0(a5)
	addi	a5,a5,4
	bne	a5,a4,.L38
	ret
	.size	configure_ro_max, .-configure_ro_max
	.align	2
	.globl	configure_ro_min
	.type	configure_ro_min, @function
configure_ro_min:
	lui	a5,%hi(muxro)
	lw	a4,%lo(muxro)(a5)
	lui	a5,%hi(triro)
	lw	a5,%lo(triro)(a5)
	li	a3,-2147483648
	sw	a3,0(a4)
	sw	a3,0(a5)
	li	a3,50528256
	addi	a2,a4,48
	addi	a3,a3,771
.L42:
	sw	a3,0(a4)
	addi	a4,a4,4
	bne	a4,a2,.L42
	li	a4,50528256
	addi	a3,a5,48
	addi	a4,a4,771
.L43:
	sw	a4,0(a5)
	addi	a5,a5,4
	bne	a5,a3,.L43
	ret
	.size	configure_ro_min, .-configure_ro_min
	.align	2
	.globl	enable_ro_config
	.type	enable_ro_config, @function
enable_ro_config:
	andi	a4,a0,15
	lui	a5,%hi(.LANCHOR0)
	addi	a5,a5,%lo(.LANCHOR0)
	slli	a4,a4,2
	add	a4,a5,a4
	lw	a3,0(a4)
	lui	a4,%hi(triro)
	lw	a2,%lo(triro)(a4)
	srli	a0,a0,4
	li	a4,-2147483648
	add	a3,a4,a3
	slli	a0,a0,2
	sw	a3,0(a2)
	add	a0,a5,a0
	lw	a3,0(a0)
	lui	a5,%hi(muxro)
	lw	a5,%lo(muxro)(a5)
	add	a4,a4,a3
	sw	a4,0(a5)
	ret
	.size	enable_ro_config, .-enable_ro_config
	.align	2
	.globl	enable_ro
	.type	enable_ro, @function
enable_ro:
	lui	a5,%hi(muxro)
	lw	a3,%lo(muxro)(a5)
	lui	a5,%hi(triro)
	lw	a4,%lo(triro)(a5)
	li	a5,-2146959360
	addi	a5,a5,-8
	sw	a5,0(a3)
	sw	a5,0(a4)
	ret
	.size	enable_ro, .-enable_ro
	.align	2
	.globl	disable_ro
	.type	disable_ro, @function
disable_ro:
	lui	a5,%hi(muxro)
	lw	a3,%lo(muxro)(a5)
	lui	a5,%hi(triro)
	lw	a4,%lo(triro)(a5)
	li	a5,-2147483648
	sw	a5,0(a3)
	sw	a5,0(a4)
	ret
	.size	disable_ro, .-disable_ro
	.globl	romap
	.globl	triro
	.globl	muxro
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	romap, @object
	.size	romap, 64
romap:
	.zero	64
	.section	.sdata,"aw"
	.align	2
	.type	triro, @object
	.size	triro, 4
triro:
	.word	134217728
	.type	muxro, @object
	.size	muxro, 4
muxro:
	.word	117440512
	.ident	"GCC: () 10.2.0"
