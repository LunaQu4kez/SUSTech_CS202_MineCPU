.text
    li t4, 0
    li t3, 0x10001000
loop:
    lw t5, 20(gp)
    nop
    beq t5, t4, loop
    lw a1, 0(gp)
    lw a2, 4(gp)
    lw a3, 8(gp)

    li s1, 0
    beq a1, s1, test_0
    li s1, 1
    beq a1, s1, test_1
    li s1, 2
    beq a1, s1, test_2
    li s1, 3
    beq a1, s1, test_3
    li s1, 4
    beq a1, s1, test_4
    li s1, 5
    beq a1, s1, test_5
    li s1, 6
    beq a1, s1, test_6
    li s1, 7
    beq a1, s1, test_7
    j loop

test_0:
    mv a0, a2
    li a7, 1
    ecall
    #sw a2, 12(gp)
    mv a0, a3
    li a7, 2
    ecall
    #sw a3, 16(gp)
    j loop

test_1:
    lb a0, 4(gp)
    li a7, 3
    ecall
    #sw a0, 40(gp)
    sw a0, 0(t3)
    j loop

test_2:
    lbu a0, 8(gp)
    li a7, 3
    ecall
    #sw a0, 40(gp)
    sw a0, 4(t3)
    j loop

test_3:
    lw t1, 0(t3)
    lw t2, 4(t3)
    nop
    beq t1, t2, led_on
    j led_off

test_4:
    lw t1, 0(t3)
    lw t2, 4(t3)
    nop
    blt t1, t2, led_on
    j led_off

test_5:
    lw t1, 0(t3)
    lw t2, 4(t3)
    nop
    bge t1, t2, led_on
    j led_off

test_6:
    lw t1, 0(t3)
    lw t2, 4(t3)
    nop
    bltu t1, t2, led_on
    j led_off

test_7:
    lw t1, 0(t3)
    lw t2, 4(t3)
    nop
    bgeu t1, t2, led_on
    j led_off

led_on:
    li t6, 3
    sw t6, 12(gp)
    j loop

led_off:
    li t6, 0
    sw t6, 12(gp)
    j loop


