addi sp, sp, -8
sw t0, 4(sp)
sw t1, 0(sp)
addi t1, zero, 1
loop: lw t0, 24(gp)
beq t0, t1, out
beq zero, zero, loop
out: lw a0, 0(gp)
lw t1, 0(sp)
lw t0, 4(sp)
addi sp, sp, 8
lw tp, 44(gp)
nop
nop
jalr zero, tp, 0
