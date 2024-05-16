# label addr
# 0x3000 .LANCHOR0
# 
# memory distribution
# 0x0000 to 0x2fff: code segment
# 0x3000 to 0x4fff: data segment
# 
# variable (base) addr
# gx[4]         .LANCHOR0
# gy[4]         .LANCHOR0+16
# st[4]         .LANCHOR0+32
# ty            0x3100
# tx            0x3104
# idx           0x3108
# cnt           0x310c
# score         0x3110
# step          0x3114
# dir           0x3118
# oy            0x311c
# ox            0x3120
# game[31][28]  0x4000

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
	jal	ghost_move
	jal	stepB
	jal	ghost_move
	jal	stepC
	jal	ghost_move
	jal	stepD
	jal	ghost_move
	jal	print_map
	nop
	jal   	checkover
       	beq    a0,zero,.lp1
       	nop
.bt2:	lw	t1,24(gp)
	nop
	beq	t1,zero,.bt2
	j	main
	nop
	

stepB:
        lui     a5,0x10013
        addi    a5,a5,0
        lui     a4,0x10013
        lw      a0,4(a5)
        lw      a1,20(a5)
        lw      a4,0x120(a4)
        lui     a5,0x10013
        lw      a5,0x11c(a5)
        sub     a3,a0,a4
        sub     a2,a1,a5
        bge     a3,zero,.B2
        sub     a3,a4,a0
.B2:
        bge     a2,zero,.B3
        sub     a2,a5,a1
.B3:
        add     a3,a3,a2
        li      a2,2
        bgt     a3,a2,.B4
        lui     a3,0x10013
        li      a2,1
        sw      a2,0x108(a3)
        lui     a3,0x10013
        sw      a4,0x104(a3)
.B21:
        lui     a4,0x10013
        sw      a5,0x100(a4)
        ret
        nop
.B4:
        lui     a3,0x10013
        lw      a3,0x118(a3)
        bne     a3,zero,.B6
        lui     a1,0x10014
        addi    a3,a4,-2
        slli    a0,a5,2
        li      a6,112
        addi    a1,a1,0
        li      a7,-1
.B8:
        blt     a3,zero,.B7
        mul     a2,a3,a6
        add     a2,a2,a0
        add     a2,a2,a1
        lw      a2,0(a2)
        beq     a2,a7,.B7
.B22:
        lui     a4,0x10013
        li      a2,1
        sw      a2,0x108(a4)
        lui     a4,0x10013
        sw      a3,0x104(a4)
        j       .B21
        nop
.B17:
        mv      a3,a2
        j       .B8
        nop
.B7:
        addi    a2,a3,1
        bne     a3,a4,.B17
        ret
        nop
.B6:
        li      a1,1
        bne     a3,a1,.B9
        lui     a1,0x10014
        addi    a3,a4,2
        slli    a0,a5,2
        li      a6,30
        li      a7,112
        addi    a1,a1,0
        li      t1,-1
.B11:
        bgt     a3,a6,.B10
        mul     a2,a3,a7
        add     a2,a2,a0
        add     a2,a2,a1
        lw      a2,0(a2)
        bne     a2,t1,.B22
.B10:
        addi    a2,a3,-1
        bne     a3,a4,.B18
        ret
.B18:
        mv      a3,a2
        j       .B11
        nop
.B9:
        bne     a3,a2,.B12
        li      a1,112
        mul     a1,a4,a1
        lui     a0,0x10014
        addi    a3,a5,-2
        addi    a0,a0,0
        li      a6,-1
.B14:
        blt     a3,zero,.B13
        slli    a2,a3,2
        add     a2,a2,a1
        add     a2,a2,a0
        lw      a2,0(a2)
        beq     a2,a6,.B13
.B23:
        lui     a5,0x10013
        li      a2,1
        sw      a2,0x108(a5)
        lui     a5,0x10013
        sw      a4,0x104(a5)
        lui     a5,0x10013
        sw      a3,0x100(a5)
        ret
        nop
.B19:
        mv      a3,a2
        j       .B14
        nop
.B13:
        addi    a2,a3,1
        bne     a3,a5,.B19
        ret
        nop
.B12:
        li      a2,3
        bne     a3,a2,.B1
        li      a1,112
        mul     a1,a4,a1
        lui     a0,0x10014
        addi    a3,a5,2
        li      a6,27
        addi    a0,a0,0
        li      a7,-1
.B16:
        bgt     a3,a6,.B15
        slli    a2,a3,2
        add     a2,a2,a1
        add     a2,a2,a0
        lw      a2,0(a2)
        bne     a2,a7,.B23
.B15:
        addi    a2,a3,-1
        bne     a5,a3,.B20
.B1:
        ret
        nop
.B20:
        mv      a3,a2
        j       .B16
        nop
        

stepC:
        lui     a5,0x10013
        lw      a4,0x120(a5)
        lui     a5,0x10013
        addi    a3,a5,0
        lw      a3,8(a3)
        slli    a4,a4,1
        li      a2,30
        sub     a4,a4,a3
        addi    a3,a5,0
        ble     a4,a2,.C2
        li      a4,30
.C3:
        lui     a5,0x10013
        lw      a5,0x11c(a5)
        lw      a3,24(a3)
        slli    a5,a5,1
        sub     a5,a5,a3
        li      a3,27
        ble     a5,a3,.C4
        li      a5,27
.C5:
        lui     a3,0x10013
        li      a2,2
        sw      a2,0x108(a3)
        lui     a3,0x10013
        sw      a4,0x104(a3)
        lui     a4,0x10013
        sw      a5,0x100(a4)
        ret
        nop
.C2:
        bge     a4,zero,.C3
        li      a4,0
        j       .C3
        nop
.C4:
        bge     a5,zero,.C5
        li      a5,0
        j       .C5
        nop


stepD:
        lui     a4,0x10013
        addi    a4,a4,0
        lui     a5,0x10013
        lw      a0,12(a4)
        lw      a1,28(a4)
        lw      a3,0x120(a5)
        lui     a4,0x10013
        lw      a4,0x11c(a4)
        sub     a5,a0,a3
        sub     a2,a1,a4
        bge     a5,zero,.D2
        sub     a5,a3,a0
.D2:
        bge     a2,zero,.D3
        sub     a2,a4,a1
.D3:
        add     a5,a5,a2
        li      a2,8
        bgt     a5,a2,.D4
        li      a3,29
        li      a4,1
.D4:
        lui     a5,0x10013
        li      a2,3
        sw      a2,0x108(a5)
        lui     a5,0x10013
        sw      a3,0x104(a5)
        lui     a5,0x10013
        sw      a4,0x100(a5)
        ret
        nop
	

stepA:
        lui     a5,0x10013
        sw      zero,0x108(a5)
        lui     a5,0x10013
        lw      a4,0x120(a5)
        lui     a5,0x10013
        sw      a4,0x104(a5)
        lui     a5,0x10013
        lw      a4,0x11c(a5)
        lui     a5,0x10013
        sw      a4,0x100(a5)
        nop
        ret
        nop


ghost_move:
        lui     a5,0x10013
        lw      a6,0x108(a5)
        lui     a2,0x10013
        addi    a4,a2,0
        slli    a1,a6,2
        add     a4,a4,a1
        lui     a3,0x10013
        lw      a5,0(a4)
        lw      a0,0x104(a3)
        lui     a3,0x10014
        lw      a4,16(a4)
        addi    a2,a2,0
        addi    a3,a3,0
        bne     a0,a5,.G2
        lui     a7,0x10013
        lw      a7,0x100(a7)
        bne     a4,a7,.G3
        li      a5,28
        mul     a0,a0,a5
        addi    a6,a6,3
        add     a0,a0,a4
        slli    a0,a0,2
        add     a0,a3,a0
        sw      a6,0(a0)
        ret
.G2:
        bge     a0,a5,.G5
        li      a7,28
        addi    a0,a5,-1
        mul     a0,a0,a7
        add     a0,a0,a4
        slli    a0,a0,2
        add     a0,a3,a0
        lw      a7,0(a0)
        li      a0,-1
        bne     a7,a0,.G6
.G3:
        lui     a0,0x10013
        lw      a0,0x100(a0)
        bge     a0,a4,.G10
        li      a0,28
        mul     a0,a5,a0
        addi    a7,a4,-1
        add     a0,a0,a7
        slli    a0,a0,2
        add     a0,a3,a0
        lw      a7,0(a0)
        li      a0,-1
        bne     a7,a0,.G9
.G10:
        li      a0,28
        mul     a0,a5,a0
        addi    a7,a4,1
        addi    t1,a4,1
        add     a0,a0,a7
        slli    a0,a0,2
        add     a0,a3,a0
        lw      a7,0(a0)
        li      a0,-1
        bne     a7,a0,.G23
        li      t1,28
        mul     a0,a5,t1
        addi    a7,a4,-1
        add     a0,a0,a7
        slli    a0,a0,2
        add     a0,a3,a0
        lw      a7,0(a0)
        li      a0,-1
        bne     a7,a0,.G9
        addi    a0,a5,1
        mul     a0,a0,t1
        add     a0,a0,a4
        slli    a0,a0,2
        add     a0,a3,a0
        lw      a0,0(a0)
        bne     a0,a7,.G7
.G6:
        addi    t1,a5,-1
.G22:
        li      a0,28
        mul     a7,t1,a0
        add     a7,a7,a4
        slli    a7,a7,2
        add     a7,a3,a7
        lw      t3,0(a7)
        li      a7,2
        bgt     t3,a7,.G1
        mul     a0,a5,a0
        add     a5,a2,a1
        lw      a7,32(a5)
        sw      t1,0(a5)
        mv      a5,t1
        add     a0,a0,a4
        slli    a0,a0,2
        add     a0,a3,a0
        sw      a7,0(a0)
.G13:
        li      a0,28
        mul     a0,a5,a0
        li      a7,2
        add     a0,a0,a4
        slli    a0,a0,2
        add     a0,a3,a0
        lw      a0,0(a0)
        bne     a0,a7,.G14
        add     a0,a2,a1
        sw      zero,32(a0)
.G15:
        add     a0,a2,a1
        lw      t1,32(a0)
        li      a7,4
        bne     t1,a7,.G16
        lw      a7,36(a2)
        sw      a7,32(a0)
.G16:
        add     a0,a2,a1
        lw      t1,32(a0)
        li      a7,5
        bne     t1,a7,.G17
        lw      a7,40(a2)
        sw      a7,32(a0)
.G17:
        add     a1,a2,a1
        lw      a7,32(a1)
        li      a0,6
        bne     a7,a0,.G18
        lw      a2,44(a2)
        sw      a2,32(a1)
.G18:
        li      a2,28
        mul     a5,a5,a2
        addi    a6,a6,3
        add     a5,a5,a4
        slli    a5,a5,2
        add     a3,a3,a5
        sw      a6,0(a3)
.G1:
        ret
        nop
.G5:
        li      a7,28
        addi    a0,a5,1
        mul     a0,a0,a7
        add     a0,a0,a4
        slli    a0,a0,2
        add     a0,a3,a0
        lw      a7,0(a0)
        li      a0,-1
        beq     a7,a0,.G3
.G7:
        addi    t1,a5,1
        j       .G22
        nop
.G9:
        addi    t1,a4,-1
.G23:
        li      a0,28
        mul     a0,a5,a0
        add     a7,a0,t1
        slli    a7,a7,2
        add     a7,a3,a7
        lw      t3,0(a7)
        li      a7,2
        bgt     t3,a7,.G1
        add     a0,a0,a4
        add     a4,a2,a1
        lw      a7,32(a4)
        slli    a0,a0,2
        add     a0,a3,a0
        sw      t1,16(a4)
        sw      a7,0(a0)
        mv      a4,t1
        j       .G13
        nop
.G14:
        add     a7,a2,a1
        sw      a0,32(a7)
        li      t1,3
        bne     a0,t1,.G15
        lw      a0,32(a2)
        sw      a0,32(a7)
        j       .G15
        nop


td:
        lw      a6,24(gp)
        lui     t1,0x10013
        lw      a3,28(gp)
        lw      a5,0x118(t1)
        lw      a2,32(gp)
        li      a7,81920
        lw      a1,36(gp)
        addi    a7,a7,-1920
        li      a4,0
        li      a0,1
        li      t3,2
        li      t4,3
.t12:
        bne     a6,a0,.t2
        bne     a5,a6,.t3
        beq     a3,a5,.t4
        beq     a2,a5,.t25
        bne     a1,a5,.t6
.t26:
        li      a4,1
.t31:
        li      a5,3
        j       .t6
        nop
.t3:
        beq     a3,a6,.t16
        beq     a2,a6,.t25
        li      a4,1
        beq     a1,a6,.t31
.t33:
        li      a5,0
.t6:
        addi    a7,a7,-1
        bne     a7,zero,.t12
        beq     a4,zero,.t1
        sw      a5,0x118(t1)
        ret
        nop
.t2:
        bne     a3,a0,.t8
        bne     a5,zero,.t9
.t7:
        beq     a2,a0,.t25
        bne     a1,a0,.t33
        j       .t26
        nop
.t16:
        li      a4,1
        j       .t7
        nop
.t9:
        beq     a2,a3,.t25
        li      a5,1
        beq     a1,a3,.t26
.t32:
        li      a4,1
        j       .t6
        nop
.t8:
        beq     a2,a0,.t10
        bne     a1,a0,.t6
        bne     a5,t3,.t26
        j       .t6
        nop
.t10:
        bne     a5,t4,.t25
        bne     a1,a2,.t6
        j       .t32
        nop
.t25:
        li      a4,1
        li      a5,2
        j       .t6
        nop
.t4:
        beq     a2,a3,.t25
        bne     a1,a3,.t32
        j       .t26
        nop
.t1:
        ret
        nop

stepO:
        lui     a4,0x10013
        lw      a5,0x114(a4)
        addi    a5,a5,1
        sw      a5,0x114(a4)
        lui     a5,0x10013
        lw      a2,0x118(a5)
        bne     a2,zero,.L2
        lui     a6,0x10013
        lw      a5,0x120(a6)
        li      a7,28
        lui     a3,0x10013
        addi    a4,a5,-1
        mul     a2,a4,a7
        lw      a0,0x11c(a3)
        lui     a3,0x10014
        addi    a1,a3,0
        addi    a3,a3,0
        add     a2,a2,a0
        slli    a2,a2,2
        add     a2,a1,a2
        lw      t1,0(a2)
        li      a1,-1
        beq     t1,a1,.L1
        mul     a5,a5,a7
        sw      a4,0x120(a6)
        add     a5,a5,a0
        slli    a5,a5,2
        add     a5,a3,a5
        sw      zero,0(a5)
        lw      a2,0(a2)
        li      a5,1
        bne     a2,a5,.L5
        lui     a2,0x10013
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
        nop
.L2:
        li      a0,1
        bne     a2,a0,.L7
        lui     a7,0x10013
        lw      a5,0x120(a7)
        li      t1,28
        lui     a3,0x10013
        addi    a4,a5,1
        mul     a1,a4,t1
        lw      a6,0x11c(a3)
        lui     a3,0x10014
        addi    a0,a3,0
        addi    a3,a3,0
        add     a1,a1,a6
        slli    a1,a1,2
        add     a1,a0,a1
        lw      t3,0(a1)
        li      a0,-1
        beq     t3,a0,.L1
        mul     a5,a5,t1
        sw      a4,0x120(a7)
        add     a5,a5,a6
        slli    a5,a5,2
        add     a5,a3,a5
        sw      zero,0(a5)
        lw      a5,0(a1)
        bne     a5,a2,.L8
        lui     a2,0x10013
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
        lui     a7,0x10013
        lw      t1,0x11c(a7)
        lui     a5,0x10013
        lw      a4,0x120(a5)
        addi    a1,t1,-1
.L17:
        li      a5,28
        mul     a5,a4,a5
        lui     a3,0x10014
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
        sw      a1,0x11c(a7)
        lw      a5,0(a2)
        bne     a5,a0,.L11
        lui     a2,0x10013
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
        lui     a7,0x10013
        lw      t1,0x11c(a7)
        lui     a5,0x10013
        lw      a4,0x120(a5)
        addi    a1,t1,1
        j       .L17
        nop

checkover:
        lui     a5,0x10013
        lw      a4,0x110(a5)
        li      a5,244
        li      a0,1
        beq     a4,a5,.L122
        lui     a5,0x10013
        lw      a4,0x120(a5)
        lui     a5,0x10013
        addi    a3,a5,0
        lw      a2,0(a3)
        addi    a5,a5,0
        bne     a2,a4,.L123
        lw      a2,16(a3)
        lui     a3,0x10013
        lw      a3,0x11c(a3)
        beq     a2,a3,.L122
.L123:
        lw      a3,4(a5)
        bne     a4,a3,.L124
        lui     a3,0x10013
        lw      a2,20(a5)
        lw      a3,0x11c(a3)
        li      a0,1
        beq     a2,a3,.L122
.L124:
        lw      a3,8(a5)
        bne     a4,a3,.L125
        lui     a3,0x10013
        lw      a2,24(a5)
        lw      a3,0x11c(a3)
        li      a0,1
        beq     a2,a3,.L122
.L125:
        lw      a3,12(a5)
        li      a0,0
        bne     a4,a3,.L122
        lw      a0,28(a5)
        lui     a5,0x10013
        lw      a5,0x11c(a5)
        sub     a0,a0,a5
        seqz    a0,a0
.L122:
        ret
        nop


print_map:
	li	t1,0xffffe00f	# adio1 = 0xffffe00f
	li	t2,0xffffd00f	# adio2 = 0xffffd00f
	li     	t0,0x10014000	# adda  = 0x10014000
	li	t3,31          # for (int i = 0; i < 31; i++)
.p2:	beq	t3,zero,.p1
	li	t4,28		# for (int j = 0; j < 28; i++)
.p3:	beq	t4,zero,.p4
	lw	t5,0(t0)	# int num = game[i][j]
	nop
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
.p7:	li	a1,32		# ch = 32
	li	a2,6		# co = 6
	sw 	a1, 0(t1)
	nop
       	sw 	a2, 0(t2)
       	nop
     	sw 	a1, 1(t1)
     	nop
     	sw 	a2, 1(t2)
     	nop
       	j	.p5
       	nop
.p8:	li	a1,1		# ch = 1
	li	a2,7		# co = 7
	sb 	a1, 0(t1)
	nop
       	sb 	a2, 0(t2)
       	nop
     	li	a1,2		# ch = 2
     	sb 	a1, 1(t1)
     	nop
     	sb 	a2, 1(t2)
     	nop
       	j	.p5
       	nop
.p9:	li	t6,0x10013118
	lw	a0,0(t6)	# a0 = dir
	li	a2,1		# co = 1
	li	t6,0
	beq	a0,t6,.p17
	li	t6,1
	beq	a0,t6,.p18
	li	t6,2
	beq	a0,t6,.p19
	li	t6,3
	beq	a0,t6,.p20
.p17:	li	a1,7
	j	.p21
	nop
.p18:	li	a1,9
	j	.p21
	nop
.p19:	li	a1,6
	j	.p21
	nop
.p20:	li	a1,3
	j	.p21
	nop
.p21:	sb 	a1, 0(t1)
	nop
       	sb 	a2, 0(t2)
       	nop
	li	t6,0
	beq	a0,t6,.p22
	li	t6,1
	beq	a0,t6,.p23
	li	t6,2
	beq	a0,t6,.p24
	li	t6,3
	beq	a0,t6,.p25
	j	.p26
	nop
.p22:	li	a1,8
	j	.p26
	nop
.p23:	li	a1,10
	j	.p26
	nop
.p24:	li	a1,4
	j	.p26
	nop
.p25:	li	a1,5
	j	.p26
	nop
.p26:  	sb 	a1, 1(t1)
	nop
     	sb 	a2, 1(t2)
     	nop
       	j	.p5
       	nop
.p10:	li	a1,11		# ch = 11
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
.p12:	li	a2,2
	j	.p16
	nop
.p13:	li	a2,3
	j	.p16
	nop
.p14:	li	a2,5
	j	.p16
	nop
.p15:	li	a2,4
	j	.p16
	nop
.p16:	sb 	a1, 0(t1)
	nop
       	sb 	a2, 0(t2)
       	nop
     	li	a1,12		# ch = 12
     	sb 	a2, 1(t2)
     	nop
     	sb 	a1, 1(t1)
     	nop
       	j	.p5
       	nop
.p11:	li	a1,32		# ch = 32
	li	a2,0		# co = 0
	sb 	a1, 0(t1)
	nop
       	sb 	a2, 0(t2)
       	nop
     	sb 	a1, 1(t1)
     	nop
     	sb 	a2, 1(t2)
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
.p1:	
	ret
	nop


init:
        lui     a5,0x10013
        li      a4,23
        sw      a4,0x120(a5)
        lui     a5,0x10013
        li      a4,13
        sw      a4,0x11c(a5)
        lui     a5,0x10013
        addi    a5,a5,0
        li      a4,17
        sw      a4,0(a5)
        li      a2,18
        li      a3,11
        sw      a4,8(a5)
        li      a4,9
        sw      a2,16(a5)
        sw      a3,4(a5)
        sw      a2,20(a5)
        sw      a4,24(a5)
        sw      a3,12(a5)
        sw      a4,28(a5)
        sw      zero,32(a5)
        sw      zero,36(a5)
        sw      zero,40(a5)
        sw      zero,44(a5)
        lui     a5,0x10013
        sw      zero,0x114(a5)
        lui     a5,0x10013
        lui     a4,0x10013
        li      a3,3
        sw      zero,0x110(a5)
        lui     a1,0x10014
        lui     a5,0x10013
        sw      a3,0x118(a4)
        sw      zero,0x10c(a5)
        addi    a3,a1,0
        li      a5,-1
        li      a4,1
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
        sw      a4,56(a2)
        sw      a4,60(a2)
        sw      a5,92(a2)
        sw      a5,96(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,124(a2)
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
        sw      a5,56(a2)
        sw      a5,60(a2)
        sw      a4,16(a2)
        sw      a4,28(a2)
        sw      a4,52(a2)
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
        sw      a5,60(a2)
        sw      a5,64(a2)
        sw      a4,0(a2)
        sw      a4,12(a2)
        sw      a4,36(a2)
        sw      a4,56(a2)
        sw      a4,68(a2)
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
        sw      a5,72(a2)
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
        sw      a5,72(a2)
        sw      a5,76(a2)
        sw      a4,8(a2)
        sw      a4,20(a2)
        sw      a4,40(a2)
        sw      a4,52(a2)
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
        sw      a5,76(a2)
        sw      a5,80(a2)
        sw      a4,4(a2)
        sw      a4,8(a2)
        sw      a4,12(a2)
        sw      a4,16(a2)
        sw      a4,20(a2)
        sw      a4,24(a2)
        sw      a4,36(a2)
        sw      a4,40(a2)
        sw      a4,940(a3)
        sw      a4,48(a2)
        sw      a4,60(a2)
        sw      a4,64(a2)
        sw      a4,68(a2)
        sw      a4,72(a2)
        sw      a4,84(a2)
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
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
        sw      a5,80(a2)
        sw      a5,84(a2)
        sw      a4,8(a2)
        sw      zero,1056(a3)
        sw      zero,1068(a3)
        sw      a4,68(a2)
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
        sw      a5,84(a2)
        sw      a5,88(a2)
        sw      zero,1168(a3)
        sw      zero,1180(a3)
        sw      a4,52(a2)
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
        sw      a5,96(a2)
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
        sw      zero,1380(a3)
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
        sw      a5,100(a2)
        sw      a5,104(a2)
        sw      zero,1416(a3)
        sw      a4,20(a2)
        sw      a4,72(a2)
        sw      zero,1492(a3)
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
        sw      zero,1644(a3)
        sw      zero,1648(a3)
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
        sw      a5,108(a2)
        sw      a5,112(a2)
        sw      a4,40(a2)
        sw      zero,1716(a3)
        sw      zero,1752(a3)
        sw      a4,100(a2)
        sw      a5,116(a2)
        sw      a5,120(a2)
        sw      a5,124(a2)
        addi    a2,a3,1792
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
        sw      a5,112(a2)
        sw      a5,116(a2)
        sw      a4,24(a2)
        sw      zero,1828(a3)
        sw      zero,1864(a3)
        sw      a4,84(a2)
        addi    a1,a1,0
        lui     a6,0x10014
        sw      a5,120(a2)
        addi    a6,a6,0
        sw      a5,1980(a1)
        li      a1,4096
        add     a1,a6,a1
        sw      a5,124(a2)
        sw      zero,1944(a3)
        addi    a2,a3,1920
        sw      zero,1948(a3)
        sw      zero,1952(a3)
        sw      zero,1956(a3)
        sw      zero,1960(a3)
        sw      zero,1964(a3)
        sw      zero,1968(a3)
        sw      zero,1972(a3)
        addi    a3,a1,-2048
        sw      a5,0(a2)
        sw      a5,4(a2)
        sw      a5,12(a2)
        sw      a5,16(a2)
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
        sw      a5,124(a2)
        sw      a5,0(a3)
        sw      a4,8(a2)
        sw      a4,68(a2)
        sw      a4,120(a2)
        sw      zero,-2044(a1)
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
        sw      zero,-2008(a1)
        sw      zero,-1932(a1)
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
        sw      a4,8(a3)
        sw      a4,12(a3)
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
        sw      a5,8(a3)
        sw      a5,12(a3)
        sw      a4,4(a3)
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
        sw      a5,12(a2)
        sw      a5,16(a2)
        sw      a4,8(a2)
        sw      a4,20(a2)
        sw      zero,-1464(a1)
        sw      a5,0(a3)
        sw      a5,4(a3)
        sw      a5,8(a3)
        sw      a5,16(a3)
        sw      a5,20(a3)
        sw      a5,32(a2)
        sw      a5,36(a2)
        sw      a5,104(a2)
        sw      a5,108(a2)
        sw      a5,124(a2)
        sw      a4,12(a3)
        sw      a4,24(a3)
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
        sw      a4,116(a2)
        sw      a4,120(a2)
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
        sw      a5,24(a3)
        sw      a5,28(a3)
        sw      a4,8(a3)
        sw      a4,20(a3)
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
        sw      a4,32(a3)
        sw      a4,36(a3)
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
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a4,0(a3)
        sw      a4,12(a3)
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
        sw      a4,40(a3)
        sw      a5,44(a3)
        sw      a5,48(a3)
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
        sw      a5,28(a3)
        addi    a1,a1,-640
        sw      a5,32(a3)
        sw      a5,36(a3)
        sw      a5,40(a3)
        sw      a5,44(a3)
        sw      a4,0(a3)
        sw      a4,4(a3)
        sw      a4,8(a3)
        sw      a4,12(a3)
        sw      a4,16(a3)
        sw      a4,20(a3)
        sw      a4,24(a3)
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

