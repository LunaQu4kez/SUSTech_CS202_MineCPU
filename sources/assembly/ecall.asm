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
    addi t0, zero, 8
    beq a7, t0, ecall_gettime
    addi t0, zero, 9
    beq a7, t0, ecall_sleep
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

# ecall_gettime: get time from timer
ecall_gettime:
    lw a0, 52(gp)
    j exit

# ecall_sleep: sleep for a while, input milliseconds
ecall_sleep:
    lw t0, 52(gp)
sleep_loop:
    lw t1, 52(gp)
    sub t1, t1, t0
    blt t1, a0, sleep_loop
    j exit

# restore context and return
exit:
    lw t1, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8
    #sret
