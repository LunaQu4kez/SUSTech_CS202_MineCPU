.text
entry:
    addi sp, sp, -8
    # save context
    sw t0, 4(sp)
    sw t1, 0(sp)
    # process
    addi t0, zero, 10
    beq a7, t0, ecall_exit
    addi t0, zero, 1
    beq a7, t0, ecall_printint1
    addi t0, zero, 2
    beq a7, t0, ecall_printint2
    addi t0, zero, 3
    beq a7, t0, ecall_printseg
    addi t0, zero, 5
    beq a7, t0, ecall_getint1
    addi t0, zero, 6
    beq a7, t0, ecall_getint2
    addi t0, zero, 7
    beq a7, t0, ecall_getint3
    j exit

# ecall_exit: infinite loop
ecall_exit:
    j ecall_exit

# ecall_getint1: read switches1 value, 1 bytes
ecall_getint1:
    lw a0, 0(gp)
    j exit

# ecall_getint2: read switches2 value, 1 bytes
ecall_getint2:
    lw a0, 4(gp)
    j exit

# ecall_getint3: read switches3 value, 1 bytes
ecall_getint3:
    lw a0, 8(gp)
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
    sw a0, 40(gp)
    j exit

# restore context and return
exit:
    lw t1, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8
    #sret
