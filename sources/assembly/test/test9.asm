main:
    li t0, 170
    li t1, 200
    slli t0, t0, 8
    addi t0, t0, 170
    slli t0, t0, 8
    addi t0, t0, 170 # t0 = 0xaaaaaa
    sw t0, 0(t1)
    li t3, 15 # t3 = 0xf
    sb t3, 1(t1)
    lw t0, 0(t1) # t0 = 0xaa0faa
    li t2, 1
    slli t2, t2, 14
    add t2, t2, t0 # t2 = 1024 * 16 + t1
    lw t0, 0(t2) # relpace (t1) with (t2), writing back
    lw t3, 0(t1) # load back
