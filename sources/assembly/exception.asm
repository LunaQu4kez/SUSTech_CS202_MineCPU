entry:
    addi sp, sp, -8
    # save context
    lw tp, 44(gp)
    sw t0, 4(sp)
    sw t1, 0(sp)
    # process
    addi t0, zero, 10
    beq a7, t0, ecall_exit
    addi t0, zero, 1
    beq a7, t0, ecall_getled

# getled: read led value
ecall_getled:
    addi a0, zero, 0
    addi a7, zero, 17
    j exit

# exit: infinite loop
ecall_exit:
    j ecall_exit

# restore context and return
exit:
    lw t1, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8
    jalr zero, tp, 0
