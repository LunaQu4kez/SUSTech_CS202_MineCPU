addi a0, zero, 8
addi a1, zero, 3
addi a2, zero, 5
addi a3, zero, 1
jal leaf
sw a0, 12(gp)
beq zero, zero, exit

leaf:
addi sp,sp,-8  # adjust stack for 2 items
sw s1, 4(sp)   # save s1 for use afterwards
sw s0, 0(sp)   # save s0 for use afterwards
add s0,a0,a1   # s0 = g + h
add s1,a2,a3   # s1 = i + j
sub a0,s0,s1   # return value (g + h) - (i + j)
lw s0, 0(sp)   # restore register s0 for caller
lw s1, 4(sp)   # restore register s1 for caller
addi sp,sp,8   # adjust stack to delete 2 items
jr ra

exit:
nop