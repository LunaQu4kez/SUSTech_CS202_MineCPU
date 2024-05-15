# label addr
# 0x3000 .LANCHOR0
# 0x4000 .LANCHOR1
# 0x5000 .LANCHOR2
# 
# memory distribution
# 0x0000 to 0x2fff: code segment
# 0x3000 to 0xcfff: data segment
# 
# variable (base) addr
# bx[300]       .LANCHOR0+0
# bxt[300]      .LANCHOR0+1200
# by[300]       .LANCHOR1-1696
# byt[300]      .LANCHOR1-496
# bh[300]       .LANCHOR1+704
# bht[300]      .LANCHOR1+1904
# gx[4]         .LANCHOR2-992
# gy[4]         .LANCHOR2-976
# st[4]         .LANCHOR2-960
# bmap[31][28]  0xa000
# game[31][28]  0xb000
# wy            0xc000
# wx            0xc004
# bit           0xc010
# bi            0xc014
# cnt           0xc100
# score         0xc110
# step          0xc120
# dir           0xc200
# oy            0xc210
# ox            0xc214

.text
main:
	jal	init
	jal	print_map
	jal	print_map
.bt1:	lw	t1,20(gp)
	nop
	beq	t1,zero,.bt1
	nop
.lp1:	jal	td
	jal	stepO
	jal	stepA
	jal	stepB
	jal	stepC
	jal	stepD
	jal	print_map
	jal   	checkover
	nop
       	beq    a0,zero,.lp1
       	nop
.bt2:	lw	t1,24(gp)
	nop
	beq	t1,zero,.bt2
	j	main
	j	main
	nop
	
lab:	lw	a1,0(gp)
	slli	a1,a1,8
	lw	a2,4(gp)
	add	a1,a1,a2
	li	a2,0x1001b000
	add	a1,a1,a2
	lw	a2,0(a1)
	sw	a2,40(gp)
	j	lab
	nop
loop:	j	loop
	nop

stepA:	ret
	nop

stepB:	ret
	nop

stepC:	ret
	nop

stepD:	ret
	nop

td:
        lw      a6,24(gp)
        lui     t1,0x1001c
        lw      a3,28(gp)
        lw      a5,0x200(t1)
        lw      a2,32(gp)
        li      a7,49152
        lw      a1,36(gp)
        addi    a7,a7,848
        li      a4,0
        li      a0,1
        li      t3,2
        li      t4,3
.td12:
        bne     a6,a0,.td2
        bne     a5,a6,.td3
        beq     a3,a5,.td4
        beq     a2,a5,.td25
        bne     a1,a5,.td6
.td26:
        li      a4,1
.td31:
        li      a5,3
        j       .td6
        nop
.td3:
        beq     a3,a6,.td16
        beq     a2,a6,.td25
        li      a4,1
        beq     a1,a6,.td31
.td33:
        li      a5,0
.td6:
        addi    a7,a7,-1
        bne     a7,zero,.td12
        beq     a4,zero,.td1
        sw      a5,0x200(t1)
        ret
.td2:
        bne     a3,a0,.td8
        bne     a5,zero,.td9
.td7:
        beq     a2,a0,.td25
        bne     a1,a0,.td33
        j       .td26
        nop
.td16:
        li      a4,1
        j       .td7
        nop
.td9:
        beq     a2,a3,.td25
        li      a5,1
        beq     a1,a3,.td26
.td32:
        li      a4,1
        j       .td6
        nop
.td8:
        beq     a2,a0,.td10
        bne     a1,a0,.td6
        bne     a5,t3,.td26
        j       .td6
        nop
.td10:
        bne     a5,t4,.td25
        bne     a1,a2,.td6
        j       .td32
        nop
.td25:
        li      a4,1
        li      a5,2
        j       .td6
        nop
.td4:
        beq     a2,a3,.td25
        bne     a1,a3,.td32
        j       .td26
        nop
.td1:   ret
        nop

stepO:
        lui     a4,0x1001c
        lw      a5,0x120(a4)
        addi    a5,a5,1
        sw      a5,0x120(a4)
        lui     a5,0x1001c
        lw      a2,0x200(a5)
        bne     a2,zero,.L2
        lui     a6,0x1001c
        lw      a5,0x214(a6)
        li      a7,28
        lui     a3,0x1001c
        addi    a4,a5,-1
        mul     a2,a4,a7
        lw      a0,0x210(a3)
        lui     a3,0x1001b
        addi    a1,a3,0
        addi    a3,a3,0
        add     a2,a2,a0
        slli    a2,a2,2
        add     a2,a1,a2
        lw      t1,0(a2)
        li      a1,-1
        beq     t1,a1,.L1
        mul     a5,a5,a7
        sw      a4,0x214(a6)
        add     a5,a5,a0
        slli    a5,a5,2
        add     a5,a3,a5
        sw      zero,0(a5)
        lw      a2,0(a2)
        li      a5,1
        bne     a2,a5,.L5
        lui     a2,0x1001c
        lw      a5,0x110(a2)
        addi    a5,a5,1
        sw      a5,0x110(a2)
.L5:
        li      a5,28
        mul     a4,a4,a5
        add     a4,a4,a0
.L12:
        slli    a4,a4,2
        add     a3,a3,a4
        li      a5,2
        sw      a5,0(a3)
.L1:
        ret
.L2:
        li      a0,1
        bne     a2,a0,.L7
        lui     a7,0x1001c
        lw      a5,0x214(a7)
        li      t1,28
        lui     a3,0x1001c
        addi    a4,a5,1
        mul     a1,a4,t1
        lw      a6,0x210(a3)
        lui     a3,0x1001b
        addi    a0,a3,0
        addi    a3,a3,0
        add     a1,a1,a6
        slli    a1,a1,2
        add     a1,a0,a1
        lw      t3,0(a1)
        li      a0,-1
        beq     t3,a0,.L1
        mul     a5,a5,t1
        sw      a4,0x214(a7)
        add     a5,a5,a6
        slli    a5,a5,2
        add     a5,a3,a5
        sw      zero,0(a5)
        lw      a5,0(a1)
        bne     a5,a2,.L8
        lui     a2,0x1001c
        lw      a5,0x110(a2)
        addi    a5,a5,1
        sw      a5,0x110(a2)
.L8:
        li      a5,28
        mul     a4,a4,a5
        add     a4,a4,a6
        j       .L12
        nop
.L7:
        li      a5,2
        bne     a2,a5,.L9
        lui     a7,0x1001c
        lw      t1,0x210(a7)
        lui     a5,0x1001c
        lw      a4,0x214(a5)
        addi    a1,t1,-1
.L17:
        li      a5,28
        mul     a5,a4,a5
        lui     a3,0x1001b
        addi    a2,a3,0
        addi    a3,a3,0
        add     a6,a5,a1
        slli    a6,a6,2
        add     a2,a2,a6
        lw      t3,0(a2)
        li      a6,-1
        beq     t3,a6,.L1
        add     a5,a5,t1
        slli    a5,a5,2
        add     a5,a3,a5
        sw      zero,0(a5)
        sw      a1,0x210(a7)
        lw      a5,0(a2)
        bne     a5,a0,.L11
        lui     a2,0x1001c
        lw      a5,0x110(a2)
        addi    a5,a5,1
        sw      a5,0x110(a2)
.L11:
        li      a5,28
        mul     a4,a4,a5
        add     a4,a4,a1
        j       .L12
        nop
.L9:
        li      a5,3
        bne     a2,a5,.L1
        lui     a7,0x1001c
        lw      t1,0x210(a7)
        lui     a5,0x1001c
        lw      a4,0x214(a5)
        addi    a1,t1,1
        j       .L17
        nop

checkover:
        lui     a5,0x1001c
        lw      a4,0x110(a5)
        li      a5,244
        li      a0,1
        beq     a4,a5,.L156
        lui     a5,0x1001c
        lw      a4,0x214(a5)
        lui     a5,0x10015
        addi    a3,a5,0
        lw      a2,-992(a3)
        addi    a5,a5,0
        bne     a2,a4,.L157
        lw      a2,-976(a3)
        lui     a3,0x1001c
        lw      a3,0x210(a3)
        beq     a2,a3,.L156
.L157:
        lw      a3,-988(a5)
        bne     a4,a3,.L158
        lui     a3,0x1001c
        lw      a2,-972(a5)
        lw      a3,0x210(a3)
        li      a0,1
        beq     a2,a3,.L156
.L158:
        lw      a3,-984(a5)
        bne     a4,a3,.L159
        lui     a3,0x1001c
        lw      a2,-968(a5)
        lw      a3,0x210(a3)
        li      a0,1
        beq     a2,a3,.L156
.L159:
        lw      a3,-980(a5)
        li      a0,0
        bne     a4,a3,.L156
        lw      a0,-964(a5)
        lui     a5,0x1001c
        lw      a5,0x210(a5)
        sub     a0,a0,a5
        seqz    a0,a0
.L156:
        ret
        nop

print_map:
	sw	s0,0(sp)
	sw	s1,-4(sp)
	sw	s2,-8(sp)
	nop
	li	t1,0xffffe00f	# adio1 = 0xffffe00f
	li	t2,0xffffd00f	# adio2 = 0xffffd00f
	li     	t0,0x1001b000	# adda  = 0x1001b000
	li	t3,31          # for (int i = 0; i < 31; i++)
.p2:	beq	t3,zero,.p1
	li	t4,28		# for (int j = 0; j < 28; i++)
.p3:	beq	t4,zero,.p4
	lw	t5,0(t0)	# int num = game[i][j]
	nop
	###
	li	s11,0x1001b020
	lw	s11,0(s11)
	li	s10,-1
	beq	s11,s10,temp1
	nop
	sw	t3,12(gp)
	sw	t4,16(gp)
	sw	s11,40(gp)
temp1:
	###
	li 	t6,-1
	beq	t5,t6,.p7	# wall
	li 	t6,1
	beq	t5,t6,.p8	# point
	li 	t6,2
	beq	t5,t6,.p9	# pacman
	li	t6,3
	bge	t5,t6,.p10	# ghost
	j	.p11		# road
	nop
.p7:	li	s1,32		# ch = 32
	li	s2,6		# co = 6
	sw 	s1, 0(t1)
	nop
       	sw 	s2, 0(t2)
       	nop
     	sw 	s1, 1(t1)
     	nop
     	sw 	s2, 1(t2)
     	nop
       	j	.p5
       	nop
.p8:	li	s1,1		# ch = 1
	li	s2,7		# co = 7
	sb 	s1, 0(t1)
	nop
       	sb 	s2, 0(t2)
       	nop
     	li	s1,2		# ch = 2
     	sb 	s1, 1(t1)
     	nop
     	sb 	s2, 1(t2)
     	nop
       	j	.p5
       	nop
.p9:	li	t6,0x1001c200
	lw	s0,0(t6)	# s0 = dir
	li	s2,1		# co = 1
	li	t6,0
	beq	s0,t6,.p17
	li	t6,1
	beq	s0,t6,.p18
	li	t6,2
	beq	s0,t6,.p19
	li	t6,3
	beq	s0,t6,.p20
.p17:	li	s1,7
	j	.p21
	nop
.p18:	li	s1,9
	j	.p21
	nop
.p19:	li	s1,6
	j	.p21
	nop
.p20:	li	s1,3
	j	.p21
	nop
.p21:	sb 	s1, 0(t1)
	nop
       	sb 	s2, 0(t2)
       	nop
	li	t6,0
	beq	s0,t6,.p22
	li	t6,1
	beq	s0,t6,.p23
	li	t6,2
	beq	s0,t6,.p24
	li	t6,3
	beq	s0,t6,.p25
	j	.p26
	nop
.p22:	li	s1,8
	j	.p26
	nop
.p23:	li	s1,10
	j	.p26
	nop
.p24:	li	s1,4
	j	.p26
	nop
.p25:	li	s1,5
	j	.p26
	nop
.p26:  	sb 	s1, 1(t1)
	nop
     	sb 	s2, 1(t2)
     	nop
       	j	.p5
       	nop
.p10:	li	s1,11		# ch = 11
	li	t6,3
	beq	t5,t6,.p12	# if num = 3
	li	t6,4
	beq	t5,t6,.p13	# if num = 4
	li	t6,5
	beq	t5,t6,.p14	# if num = 5
	li	t6,6
	beq	t5,t6,.p15	# if num = 6
	j	.p16
	nop
.p12:	li	s2,2
	j	.p16
	nop
.p13:	li	s2,3
	j	.p16
	nop
.p14:	li	s2,5
	j	.p16
	nop
.p15:	li	s2,4
	j	.p16
	nop
.p16:	sb 	s1, 0(t1)
	nop
       	sb 	s2, 0(t2)
       	nop
     	li	s1,12		# ch = 12
     	sb 	s2, 1(t2)
     	nop
     	sb 	s1, 1(t1)
     	nop
       	j	.p5
       	nop
.p11:	li	s1,32		# ch = 32
	li	s2,0		# co = 0
	sb 	s1, 0(t1)
	nop
       	sb 	s2, 0(t2)
       	nop
     	sb 	s1, 1(t1)
     	nop
     	sb 	s2, 1(t2)
     	nop
       	j	.p5
	nop
.p5:	addi	t1,t1,2
	addi	t2,t2,2
	addi	t0,t0,4
	addi	t4,t4,-1
	j 	.p3
	nop
.p4:	addi	t1,t1,40
	addi	t2,t2,40
	addi	t3,t3,-1
	j 	.p2
	nop
.p1:	lw	s0,0(sp)
	lw	s1,-4(sp)
	lw	s2,-8(sp)
	ret
	nop

init:
        lui     a5,0x1001c
        li      a4,23
        sw      a4,0x214(a5)
        lui     a5,0x1001c
        li      a4,13
        sw      a4,0x210(a5)
        lui     a4,0x10015
        addi    a4,a4,0x000
        addi    a5,a4,-1024
        li      a3,17
        sw      a3,32(a5)
        li      a1,18
        li      a2,11
        sw      a3,40(a5)
        li      a3,9
        sw      a1,48(a5)
        sw      a2,36(a5)
        sw      a1,52(a5)
        sw      a3,56(a5)
        sw      a2,44(a5)
        sw      a3,60(a5)
        lui     a5,0x1001c
        li      a3,3
        sw      a3,0x200(a5)
        lui     a5,0x1001c
        sw      zero,0x120(a5)
        lui     a5,0x1001c
        sw      zero,0x110(a5)
        lui     a5,0x1001c
        sw      zero,0x100(a5)
        lui     a5,0x1001c
        lui     a6,0x1001b
        sw      zero,0x014(a5)
        lui     a5,0x1001c
        addi    a3,a6,0x000
        sw      zero,0x010(a5)
        li      a5,-1
        addi    a2,a3,128
        sw      a5,0(a3)
        sw      a5,4(a3)
        sw      a5,8(a3)
        sw      a5,12(a3)
        sw      a5,16(a3)
        sw      a5,20(a3)
        sw      a5,24(a3)
        sw      a5,28(a3)
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      zero,-960(a4)
        sw      zero,-956(a4)
        sw      zero,-952(a4)
        sw      zero,-948(a4)
        li      a4,1
        sw      a5,48(a3)
        sw      a5,52(a3)
        sw      a5,56(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,68(a3)
        sw      a5,72(a3)
        sw      a5,76(a3)
        sw      a5,80(a3)
        sw      a5,84(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,96(a3)
        sw      a5,100(a3)
        sw      a5,104(a3)
        sw      a5,108(a3)
        sw      a5,112(a3)
        sw      a5,36(a2)
        sw      a5,40(a2)
        sw      a4,116(a3)
        sw      a4,120(a3)
        sw      a4,124(a3)
        sw      a4,0(a2)
        sw      a4,4(a2)
        sw      a4,8(a2)
        sw      a4,12(a2)
        sw      a4,16(a2)
        sw      a4,20(a2)
        sw      a4,24(a2)
        sw      a4,28(a2)
        sw      a4,32(a2)
        sw      a4,44(a2)
        sw      a4,48(a2)
        sw      a4,52(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,124(a2)
        sw      a4,56(a2)
        sw      a4,60(a2)
        sw      a4,64(a2)
        sw      a4,68(a2)
        sw      a4,72(a2)
        sw      a4,76(a2)
        sw      a4,80(a2)
        sw      a4,84(a2)
        sw      a4,88(a2)
        sw      a4,100(a2)
        sw      a4,120(a2)
        addi    a2,a3,256
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,8(a2)
        sw      a5,12(a2)
        sw      a5,20(a2)
        sw      a5,24(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a4,16(a2)
        sw      a4,28(a2)
        sw      a4,52(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,68(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
        sw      a4,72(a2)
        sw      a4,84(a2)
        sw      a4,104(a2)
        addi    a2,a3,384
        sw      a5,4(a2)
        sw      a5,8(a2)
        sw      a5,16(a2)
        sw      a5,20(a2)
        sw      a5,24(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,52(a2)
        sw      a4,0(a2)
        sw      a4,12(a2)
        sw      a4,36(a2)
        sw      a4,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a4,68(a2)
        sw      a4,88(a2)
        sw      a4,112(a2)
        sw      a4,124(a2)
        addi    a2,a3,512
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,8(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,24(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a4,20(a2)
        sw      a4,40(a2)
        sw      a4,52(a2)
        sw      a4,56(a2)
        sw      a4,60(a2)
        sw      a4,64(a2)
        sw      a4,68(a2)
        sw      a4,72(a2)
        sw      a4,76(a2)
        sw      a4,80(a2)
        sw      a4,84(a2)
        sw      a4,88(a2)
        sw      a4,92(a2)
        sw      a4,96(a2)
        sw      a4,100(a2)
        sw      a4,104(a2)
        sw      a4,108(a2)
        sw      a4,112(a2)
        sw      a4,116(a2)
        sw      a4,120(a2)
        sw      a4,124(a2)
        addi    a2,a3,640
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,52(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a4,0(a2)
        sw      a4,4(a2)
        sw      a4,8(a2)
        sw      a4,12(a2)
        sw      a4,16(a2)
        sw      a4,20(a2)
        sw      a4,24(a2)
        sw      a4,36(a2)
        sw      a4,56(a2)
        sw      a4,68(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
        sw      a4,104(a2)
        sw      a4,116(a2)
        addi    a2,a3,768
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,24(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,68(a2)
        sw      a4,8(a2)
        sw      a4,20(a2)
        sw      a4,40(a2)
        sw      a4,52(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,124(a2)
        sw      a4,88(a2)
        sw      a4,100(a2)
        sw      a4,120(a2)
        addi    a2,a3,896
        sw      a5,0(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,52(a2)
        sw      a5,56(a2)
        sw      a4,4(a2)
        sw      a4,8(a2)
        sw      a4,12(a2)
        sw      a4,16(a2)
        sw      a4,20(a2)
        sw      a4,24(a2)
        sw      a4,36(a2)
        sw      a4,936(a3)
        sw      a4,44(a2)
        sw      a4,48(a2)
        sw      a4,60(a2)
        sw      a4,64(a2)
        sw      a4,68(a2)
        sw      a4,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
        sw      a4,84(a2)
        sw      a4,88(a2)
        sw      a4,92(a2)
        sw      a4,96(a2)
        sw      a4,100(a2)
        sw      a4,104(a2)
        addi    a2,a3,1024
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,20(a2)
        sw      a5,24(a2)
        sw      a5,28(a2)
        sw      a5,36(a2)
        sw      a5,40(a2)
        sw      a5,48(a2)
        sw      a5,52(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a4,8(a2)
        sw      zero,1056(a3)
        sw      zero,1068(a3)
        sw      a4,68(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,124(a2)
        sw      a4,120(a2)
        addi    a2,a3,1152
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,8(a2)
        sw      a5,12(a2)
        sw      a5,20(a2)
        sw      a5,24(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,68(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      zero,1168(a3)
        sw      zero,1180(a3)
        sw      a4,52(a2)
        sw      a5,84(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a4,104(a2)
        addi    a2,a3,1280
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,52(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,68(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,92(a2)
        sw      zero,1272(a3)
        sw      zero,1276(a3)
        sw      zero,1280(a3)
        sw      zero,1284(a3)
        sw      zero,1288(a3)
        sw      zero,1292(a3)
        sw      zero,1296(a3)
        sw      zero,1300(a3)
        sw      a4,36(a2)
        sw      a4,88(a2)
        sw      a5,96(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
        addi    a2,a3,1408
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,24(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,52(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,68(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      zero,1380(a3)
        sw      zero,1416(a3)
        sw      a4,20(a2)
        sw      a4,72(a2)
        sw      zero,1492(a3)
        sw      a5,100(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,124(a2)
        addi    a2,a3,1536
        sw      a5,0(a2)
        sw      a5,8(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,20(a2)
        sw      a5,24(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,52(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      zero,1528(a3)
        sw      a4,4(a2)
        sw      a4,56(a2)
        sw      zero,1596(a3)
        sw      zero,1600(a3)
        sw      zero,1604(a3)
        sw      zero,1640(a3)
        sw      a5,120(a2)
        sw      a5,124(a2)
        sw      a4,116(a2)
        addi    a2,a3,1664
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,8(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,20(a2)
        sw      a5,24(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,68(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,104(a2)
        sw      zero,1644(a3)
        sw      zero,1648(a3)
        sw      a4,40(a2)
        sw      zero,1716(a3)
        sw      zero,1752(a3)
        sw      a4,100(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
        addi    a2,a3,1792
        addi    a1,a6,0x000
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,8(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,20(a2)
        sw      a5,28(a2)
        sw      a5,32(a2)
        sw      a5,40(a2)
        sw      a5,44(a2)
        sw      a5,48(a2)
        sw      a5,52(a2)
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,68(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a4,24(a2)
        sw      zero,1828(a3)
        sw      zero,1864(a3)
        sw      a4,84(a2)
        sw      a5,112(a2)
        addi    a6,a6,0x000
        sw      zero,1968(a1)
        sw      zero,1972(a1)
        li      a1,4096
        add     a1,a6,a1
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
        addi    a2,a3,1920
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a5,88(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,100(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a4,8(a2)
        sw      zero,1944(a3)
        sw      zero,1948(a3)
        sw      zero,1952(a3)
        sw      zero,1956(a3)
        sw      zero,1960(a3)
        sw      zero,1964(a3)
        sw      a4,68(a2)
        addi    a3,a1,-2048
        sw      a4,120(a2)
        sw      a5,124(a2)
        sw      zero,-2044(a1)
        sw      zero,-2008(a1)
        sw      zero,-1932(a1)
        sw      a5,0(a3)
        sw      a5,8(a3)
        sw      a5,12(a3)
        sw      a5,16(a3)
        sw      a5,20(a3)
        sw      a5,24(a3)
        sw      a5,28(a3)
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,56(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,68(a3)
        sw      a5,72(a3)
        sw      a5,76(a3)
        sw      a5,80(a3)
        sw      a5,84(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,96(a3)
        sw      a5,100(a3)
        sw      a5,108(a3)
        sw      a5,112(a3)
        sw      a5,120(a3)
        sw      a5,124(a3)
        sw      a4,52(a3)
        sw      a4,104(a3)
        addi    a3,a1,-1920
        sw      a5,0(a3)
        sw      a5,4(a3)
        sw      a5,8(a3)
        sw      a5,12(a3)
        sw      a5,16(a3)
        sw      a5,20(a3)
        sw      a5,28(a3)
        sw      a5,32(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,52(a3)
        sw      a5,56(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,116(a3)
        sw      a5,120(a3)
        sw      a4,36(a3)
        sw      a4,68(a3)
        sw      a4,72(a3)
        sw      a4,76(a3)
        sw      a4,80(a3)
        sw      a4,84(a3)
        sw      a4,88(a3)
        sw      a4,92(a3)
        sw      a4,96(a3)
        sw      a4,100(a3)
        sw      a4,104(a3)
        sw      a4,108(a3)
        sw      a4,112(a3)
        sw      a4,124(a3)
        addi    a3,a1,-1792
        sw      zero,-1896(a1)
        sw      a4,0(a3)
        sw      a4,4(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,56(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,68(a3)
        sw      a5,76(a3)
        sw      a5,80(a3)
        sw      a5,84(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,100(a3)
        sw      a5,104(a3)
        sw      a5,112(a3)
        sw      a5,116(a3)
        sw      a5,120(a3)
        sw      a5,124(a3)
        sw      a4,8(a3)
        sw      a4,12(a3)
        sw      a4,16(a3)
        sw      a4,20(a3)
        sw      a4,24(a3)
        sw      a4,28(a3)
        sw      a4,32(a3)
        sw      a4,36(a3)
        sw      a4,40(a3)
        sw      a4,52(a3)
        sw      a4,72(a3)
        sw      a4,96(a3)
        sw      a4,108(a3)
        addi    a3,a1,-1664
        mv      a0,a2
        sw      a5,0(a3)
        addi    a2,a1,-1536
        sw      a4,4(a3)
        sw      a5,8(a3)
        sw      a5,12(a3)
        sw      a5,16(a3)
        sw      a5,20(a3)
        sw      a5,28(a3)
        sw      a5,32(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,52(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,68(a3)
        sw      a5,72(a3)
        sw      a5,76(a3)
        sw      a5,84(a3)
        sw      a5,88(a3)
        sw      a5,96(a3)
        sw      a5,100(a3)
        sw      a5,104(a3)
        sw      a5,108(a3)
        sw      a5,112(a3)
        sw      a5,120(a3)
        sw      a5,124(a3)
        sw      a4,24(a3)
        sw      a4,36(a3)
        sw      a4,56(a3)
        sw      a4,80(a3)
        sw      a4,92(a3)
        sw      a4,116(a3)
        sw      a5,0(a2)
        addi    a3,a1,-1408
        sw      a5,4(a2)
        sw      a4,8(a2)
        sw      a5,12(a2)
        sw      zero,-1464(a1)
        sw      a4,-1420(a1)
        sw      a5,0(a3)
        sw      a5,4(a3)
        sw      a5,8(a3)
        sw      a5,16(a3)
        sw      a5,16(a2)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,124(a2)
        sw      a4,12(a3)
        sw      a4,20(a2)
        sw      a4,24(a2)
        sw      a4,28(a2)
        sw      a4,40(a2)
        sw      a4,44(a2)
        sw      a4,48(a2)
        sw      a4,52(a2)
        sw      a4,56(a2)
        sw      a4,60(a2)
        sw      a4,64(a2)
        sw      a4,76(a2)
        sw      a4,80(a2)
        sw      a4,84(a2)
        sw      a4,88(a2)
        sw      a4,92(a2)
        sw      a4,96(a2)
        sw      a4,100(a2)
        sw      a4,112(a2)
        sw      a4,120(a2)
        sw      a5,20(a3)
        sw      a5,28(a3)
        sw      a5,32(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,52(a3)
        sw      a5,56(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,68(a3)
        sw      a5,76(a3)
        sw      a5,80(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,100(a3)
        sw      a5,104(a3)
        sw      a5,108(a3)
        sw      a5,112(a3)
        sw      a5,116(a3)
        sw      a5,120(a3)
        sw      a4,24(a3)
        sw      a4,36(a3)
        sw      a4,72(a3)
        sw      a4,84(a3)
        sw      a4,96(a3)
        sw      a4,124(a3)
        addi    a3,a1,-1280
        sw      a5,0(a3)
        sw      a5,4(a3)
        sw      a5,12(a3)
        sw      a5,16(a3)
        sw      a4,8(a3)
        sw      a4,20(a3)
        sw      a5,24(a3)
        sw      a5,28(a3)
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,52(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,72(a3)
        sw      a5,76(a3)
        sw      a5,84(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,96(a3)
        sw      a5,124(a3)
        sw      a4,56(a3)
        sw      a4,68(a3)
        sw      a4,80(a3)
        sw      a4,100(a3)
        sw      a4,104(a3)
        sw      a4,108(a3)
        sw      a4,112(a3)
        sw      a4,116(a3)
        sw      a4,120(a3)
        addi    a3,a1,-1152
        sw      a5,0(a3)
        sw      a5,20(a3)
        sw      a5,24(a3)
        sw      a4,4(a3)
        sw      a4,8(a3)
        sw      a4,12(a3)
        sw      a4,16(a3)
        sw      a4,28(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,76(a3)
        sw      a5,80(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,96(a3)
        sw      a5,100(a3)
        sw      a5,104(a3)
        sw      a5,108(a3)
        sw      a5,112(a3)
        sw      a5,116(a3)
        sw      a5,120(a3)
        sw      a5,124(a3)
        sw      a4,32(a3)
        sw      a4,36(a3)
        sw      a4,40(a3)
        sw      a4,52(a3)
        sw      a4,56(a3)
        sw      a4,60(a3)
        sw      a4,64(a3)
        sw      a4,68(a3)
        sw      a4,72(a3)
        sw      a4,84(a3)
        addi    a3,a1,-1024
        sw      a5,4(a3)
        sw      a5,8(a3)
        sw      a5,16(a3)
        sw      a5,20(a3)
        sw      a5,24(a3)
        sw      a5,28(a3)
        sw      a4,0(a3)
        sw      a4,12(a3)
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,52(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,72(a3)
        sw      a5,76(a3)
        sw      a5,80(a3)
        sw      a5,84(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,96(a3)
        sw      a5,100(a3)
        sw      a5,104(a3)
        sw      a5,108(a3)
        sw      a5,116(a3)
        sw      a5,120(a3)
        sw      a4,56(a3)
        sw      a4,68(a3)
        sw      a4,112(a3)
        sw      a4,124(a3)
        addi    a3,a1,-896
        sw      a5,0(a3)
        sw      a5,4(a3)
        sw      a5,8(a3)
        sw      a5,12(a3)
        sw      a5,16(a3)
        sw      a5,20(a3)
        sw      a5,24(a3)
        sw      a5,28(a3)
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a4,40(a3)
        sw      a4,52(a3)
        sw      a4,56(a3)
        sw      a4,60(a3)
        sw      a4,64(a3)
        sw      a4,68(a3)
        sw      a4,72(a3)
        sw      a4,76(a3)
        sw      a4,80(a3)
        sw      a4,84(a3)
        sw      a4,88(a3)
        sw      a4,92(a3)
        sw      a4,96(a3)
        sw      a4,100(a3)
        sw      a4,104(a3)
        sw      a4,108(a3)
        sw      a4,112(a3)
        sw      a4,116(a3)
        sw      a4,120(a3)
        sw      a4,124(a3)
        addi    a3,a1,-768
        sw      a4,-752(a1)
        sw      a5,28(a3)
        addi    a1,a1,-640
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a4,0(a3)
        sw      a4,4(a3)
        sw      a4,8(a3)
        sw      a4,12(a3)
        sw      a4,20(a3)
        sw      a4,24(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
        sw      a5,52(a3)
        sw      a5,56(a3)
        sw      a5,60(a3)
        sw      a5,64(a3)
        sw      a5,68(a3)
        sw      a5,72(a3)
        sw      a5,76(a3)
        sw      a5,80(a3)
        sw      a5,84(a3)
        sw      a5,88(a3)
        sw      a5,92(a3)
        sw      a5,96(a3)
        sw      a5,100(a3)
        sw      a5,104(a3)
        sw      a5,108(a3)
        sw      a5,112(a3)
        sw      a5,116(a3)
        sw      a5,120(a3)
        sw      a5,124(a3)
        sw      a5,0(a1)
        sw      a5,4(a1)
        sw      a5,8(a1)
        sw      a5,12(a1)
        li      a5,2
        sw      a5,68(a2)
        li      a5,3
        sw      a5,56(a0)
        li      a5,4
        sw      a5,1304(a6)
        li      a5,5
        sw      a5,20(a0)
        li      a5,6
        sw      a5,1268(a6)
        ret

