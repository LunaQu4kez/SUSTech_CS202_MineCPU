begin: 	addi s0, zero, 8
	addi t0, zero, 1
loop1: 	lw a0, 20(gp)
       	nop
       	beq a0, t0, out1
       	jal zero, loop1
out1:	lw s0, 0(gp)
loop2: 	lw a0, 24(gp)
       	nop
       	beq a0, t0, out2
       	jal zero, loop2
out2:	lw s1, 0(gp)
loop3: 	lw a0, 28(gp)
       	nop
       	beq a0, t0, out3
       	jal zero, loop3
out3:	lw s2, 0(gp)

	addi t1, zero, 0
	beq s0, t1, c0
	addi t1, zero, 3
	beq s0, t1, c3
	j begin
c0:  	sw s1, 12(gp)
	sw s2, 16(gp)
	j begin
c3:	beq s1, s2, m1
	sw t0, 16(gp)
	jal zero, m2
m1:	sw t0, 12(gp)
m2:	j begin
