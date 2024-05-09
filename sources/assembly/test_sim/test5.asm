    li t2, 4
loop: 
    bge t1, t2, out
    addi t1, t1, 1
    beq zero, zero, loop
out:
    sw t1, 12(gp)
