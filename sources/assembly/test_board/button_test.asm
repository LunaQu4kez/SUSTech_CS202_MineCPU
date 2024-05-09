	addi t0, t0, 1
loop:  	lw t1, 20(gp)
	nop
	beq t0, t1, out
	jal zero, loop
out: 	lw t2, 0(gp)
	sw t2, 12(gp)
	jal zero, loop
