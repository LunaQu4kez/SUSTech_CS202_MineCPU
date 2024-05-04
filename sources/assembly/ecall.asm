entry:
    addi sp, sp, -8
    # save context
    lw tp, 40(gp)
    sw t0, 4(sp)
    sw t1, 0(sp)
    # process
    addi t0, zero, 10
    beq a7, t0, ecall_exit
    addi t0, zero, 5
    beq a7, t0, ecall_getint1
    addi t0, zero, 6
    beq a7, t0, ecall_getint2
    addi t0, zero, 1
    beq a7, t0, ecall_printint1
    addi t0, zero, 2
    beq a7, t0, ecall_printint2
    addi t0, zero, 3
    beq a7, t0, ecall_printseg
    beq zero, zero, exit

# ecall_exit: infinite loop
ecall_exit:
    j ecall_exit

# ecall_getint1: read switches1 value, 1 bytes
ecall_getint1:
    lw a0, 0(gp)
    j exit

# ecall_getint2: read switches1 value, 1 bytes
ecall_getint2:
    lw a0, 4(gp)
    j exit
    
# ecall_printint1: print int to led1, 1 bytes
ecall_printint1:
    sw a0, 12(gp)
    j exit
    
# ecall_printint2: print int to led2, 1 bytes
ecall_printint2:
    sw a0, 16(gp)
    j exit

# ecall_printseg: print a word to seg7tube
ecall_printseg:
    addi t1, zero, 0
    li t0, 0xf0000000
    and t0, a0, t0
    srli t0, t0, 1
    add t1, t1, t0
    li t0, 0x0f000000
    and t0, a0, t0
    srli t0, t0, 2
    add t1, t1, t0
    li t0, 0x00f00000
    and t0, a0, t0
    srli t0, t0, 3
    add t1, t1, t0
    li t0, 0x000f0000
    and t0, a0, t0
    srli t0, t0, 4
    add t1, t1, t0
    sw t1, 44(gp)
    addi t1, zero, 0
    li t0, 0x0000f000
    and t0, a0, t0
    slli t0, t0, 4
    add t1, t1, t0
    li t0, 0x00000f00
    and t0, a0, t0
    slli t0, t0, 3
    add t1, t1, t0
    li t0, 0x000000f0
    and t0, a0, t0
    slli t0, t0, 2
    add t1, t1, t0
    li t0, 0x0000000f
    and t0, a0, t0
    slli t0, t0, 1
    add t1, t1, t0
    sw t1, 48(gp)

# restore context and return
exit:
    lw t1, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8
    jalr zero, tp, 0
