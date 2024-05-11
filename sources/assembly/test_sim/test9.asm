entry:
    li t0, 170       # data1 = 0xaa
    li t1, 15        # data2 = 0xf
    li t2, 20        # address1
    li t3, 1         # address2 
    slli t3, t3, 8
    add t3, t3, t2   # t2 = 256 + t1
    slli t0, t0, 8
    addi t0, t0, 170
    slli t0, t0, 8
    addi t0, t0, 170 # t0 = 0xaaaaaa
main:
    sw t0, 0(t2)     # store 0xaaaaaa to address1
    sb t1, 1(t2)     # store 0xf to address1 + 1 -> 0xaa0faa
    lw t0, 0(t2)     # t0 = 0xaa0faa
    lw t0, 0(t3)     # relpace (t2) with (t2), writing back
    lw t0, 0(t3)     # load back
    lb t0, 0(t3)     # replace
    sb t1, 2(t2)     # load back and store -> 0x0f0faa

