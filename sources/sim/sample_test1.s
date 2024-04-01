	.file	"test.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	a
	.data
	.align	2
	.type	a, @object
	.size	a, 80
a:
	.word	2
	.word	12
	.word	14
	.word	6
	.word	13
	.word	15
	.word	16
	.word	10
	.word	0
	.word	18
	.word	11
	.word	19
	.word	9
	.word	1
	.word	7
	.word	5
	.word	4
	.word	3
	.word	8
	.word	17
	.text
	.align	2
	.globl	bubble_sort
	.type	bubble_sort, @function
bubble_sort:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	zero,-24(s0)
	j	.L2
.L6:
	sw	zero,-20(s0)
	j	.L3
.L5:
	lui	a5,%hi(a)
	addi	a4,a5,%lo(a)
	lw	a5,-20(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	lui	a3,%hi(a)
	addi	a3,a3,%lo(a)
	slli	a5,a5,2
	add	a5,a3,a5
	lw	a5,0(a5)
	ble	a4,a5,.L4
	lui	a5,%hi(a)
	addi	a4,a5,%lo(a)
	lw	a5,-20(s0)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-28(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	lui	a4,%hi(a)
	addi	a4,a4,%lo(a)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a4,0(a5)
	lui	a5,%hi(a)
	addi	a3,a5,%lo(a)
	lw	a5,-20(s0)
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	lui	a4,%hi(a)
	addi	a4,a4,%lo(a)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a4,-28(s0)
	sw	a4,0(a5)
.L4:
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L3:
	li	a4,19
	lw	a5,-24(s0)
	sub	a5,a4,a5
	lw	a4,-20(s0)
	blt	a4,a5,.L5
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a4,-24(s0)
	li	a5,19
	ble	a4,a5,.L6
	nop
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	bubble_sort, .-bubble_sort
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	call	bubble_sort
	li	a5,0
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
