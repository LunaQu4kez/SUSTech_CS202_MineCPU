li t1, 7
addi t2, t2, 1
beq zero, zero, out
addi t2, t2, 1
addi t2, t2, 1
addi t2, t2, 1
out:
    sw t2, 12(gp)
