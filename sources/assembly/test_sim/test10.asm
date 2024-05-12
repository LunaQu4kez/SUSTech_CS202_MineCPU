main:
    li t4, 10
    li t5, 10
    sw t5, 0(sp)
    nop
loop:
    lw t3, 0(sp)
    beq t3, t4, loop
    li a7, 10
    li a6, 10
