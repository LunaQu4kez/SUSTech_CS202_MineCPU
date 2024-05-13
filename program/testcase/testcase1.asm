.text
    li t4, 0
    li t3, 0x10001000
loop:
    lw t5, 20(gp)
    beq t5, t4, loop
    lw a1, 8(gp)
    lw a2, 0(gp)
    lw a3, 4(gp)

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
    sw a2, 12(gp)
    sw a3, 16(gp)
    j loop

test_1:
    lb a0, 0(gp)
    li a7, 3
    ecall
    sw a0, 0(t3)
    j led_off

test_2:
    lbu a0, 4(gp)
    li a7, 3
    ecall
    sw a0, 4(t3)
    j led_off

test_3:
    lw t1, 0(t3)
    lw t2, 4(t3)
    beq t1, t2, led_on
    j led_off

test_4:
    lw t1, 0(t3)
    lw t2, 4(t3)
    blt t1, t2, led_on
    j led_off

test_5:
    lw t1, 0(t3)
    lw t2, 4(t3)
    bge t1, t2, led_on
    j led_off

test_6:
    lw t1, 0(t3)
    lw t2, 4(t3)
    bltu t1, t2, led_on
    j led_off

test_7:
    lw t1, 0(t3)
    lw t2, 4(t3)
    bgeu t1, t2, led_on
    j led_off

led_on:
    li t6, 192
    sw t6, 12(gp)
    j loop

led_off:
    li t6, 0
    sw t6, 12(gp)
    j loop


