li t0, 100
sw t0, 0(t0)
lw t1, 0(t0)
li t2, 1
slli t2, t2, 14
add t2, t2, t0
lw t1, 0(t2)
