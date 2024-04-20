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
    beq a7, t0, ecall_getint
    beq zero, zero, exit

# ecall_exit: infinite loop
ecall_exit:
    j ecall_exit

# ecall_getint: read switches1 value, 1 bytes
ecall_getint:
    lw a0, 0(gp)
    j exit

# ecall_printint: print a word to seg7tube
ecall_printint:
    # TODO

# ecall_getbutton: return a value indicates the button pressed
ecall_getbutton:
    # TODO

# restore context and return
exit:
    lw t1, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8
    jalr zero, tp, 0
