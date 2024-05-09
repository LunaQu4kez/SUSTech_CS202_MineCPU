loop:
lw t0, 0(gp)
lw t1, 4(gp)
sw t0, 12(gp)
sw t1, 16(gp)
beq zero, zero, loop
