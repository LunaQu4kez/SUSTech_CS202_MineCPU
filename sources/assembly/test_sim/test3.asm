li t1, 0x10007f00
addi t2, t2, 13
sw t2, 0(t1)
lw t3, 0(t1)
xori t3, t3, -1
addi t0, zero, 10
sw t3, 12(gp)
