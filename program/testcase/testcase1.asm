.text
entry:
    addi sp, sp, -16
main:
    lw a0, 8(gp)
    li a1, 0
    beq a0, a1, case0
    li a1, 1
    beq a0, a1, case1
    li a1, 2
    beq a0, a1, case2
    li a1, 3
    beq a0, a1, case3
    li a1, 4
    beq a0, a1, case4
    li a1, 5
    beq a0, a1, case5
    li a1, 6
    beq a0, a1, case6
    li a1, 7
    beq a0, a1, case7
    j main

case0:
    lw t0, 0(gp)
    lw t1, 4(gp)
    sw t0, 12(gp)
    sw t1, 16(gp)
    j main

case1:
    lw t0, 0(gp)
    sw t0, 12(gp)
    sw t0, 0(sp)
    lb t0, 0(sp)
    sw t0, 40(gp)
    j main

case2:
    lw t1, 0(gp)
    sw t1, 12(gp)
    sw t1, 4(sp)
    lbu t1, 4(sp)
    sw t1, 40(gp)
    j main

case3:
    lb t0, 0(sp)
    lbu t1, 4(sp)
    beq t0, t1, light
    j main

case4:
    lb t0, 0(sp)
    lbu t1, 4(sp)
    blt t0, t1, light
    j main

case5:
    lb t0, 0(sp)
    lbu t1, 4(sp)
    bge t0, t1, light
    j main

case6:
    lb t0, 0(sp)
    lbu t1, 4(sp)
    bltu t0, t1, light
    j main

case7:
    lb t0, 0(sp)
    lbu t1, 4(sp)
    bgeu t0, t1, light
    j main

light:
    li t3, 255
    sw t3, 16(gp)
    j main