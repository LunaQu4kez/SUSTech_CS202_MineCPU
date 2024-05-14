.text
loop:
    lw t5, 20(gp)
    beq t5, t4, loop
    lw a1, 8(gp)
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
	lw a2,0(gp)
	li t0,0
	count:
	beq a2,zero,exit_0
	srli a2,a2,1
	addi t0,t0,1
	j count
	exit_0:
	addi t1,zero,8
	sub t0,t1,t0
	sw t0,12(gp)
	j loop


test_1:
	lw a2,0(gp)
	lw a3,4(gp)
	addi t1,a3,0
	andi t2,a2,3
	slli t2,t2,8
	add t1,t1,t2
	andi t2,a2,124
	srli t2,t2,2
	addi t1,t1,1024
	li a5,128
	and t3,a2,a5
	#t1是已经加了1的f，t2是位移之后的e,t3是没有位移的符号位
	li t6,25
	sub t4,t6,t2
	bge t4,zero,shift_right_1  #右移
	sub t4,t2,t6
	sll t5,t1,t4
	j out_1
	
out_1:
	beq t3,zero,positive_1_1
	sub t5,zero,t5
	lw t5,40(gp)
	j loop
	
positive_1_1:
	lw t5,40(gp)
	j loop
	
shift_right_1:
	srl t5,t1,t4
	li t6,32
	sub t4,t6,t4
	sll t1,t1,t4
	beq t1,zero,out_1
	beq t3,zero,positive_1_2
	sub t5,zero,t5
	lw t5,40(gp)
	j loop
	
positive_1_2:
	addi t5,t5,1
	lw t5,40(gp)
	j loop
	

test_2:
	lw a2,0(gp)
	lw a3,4(gp)
	addi t1,a3,0
	andi t2,a2,3
	slli t2,t2,8
	add t1,t1,t2
	andi t2,a2,124
	srli t2,t2,2
	addi t1,t1,1024
	li a5,128
	and t3,a2,a5
	#t1是已经加了1的f，t2是位移之后的e,t3是没有位移的符号位
	li t6,25
	sub t4,t6,t2
	bge t4,zero,shift_right_2  #右移
	sub t4,t2,t6
	sll t5,t1,t4
	j out_1
	
shift_right_2:
	srl t5,t1,t4
	li t6,32
	sub t4,t6,t4
	sll t1,t1,t4
	beq t1,zero,out_1
	beq t3,zero,positive_2_2
	addi t5,t5,1
	sub t5,zero,t5
	lw t5,40(gp)
	j loop
	
positive_2_2:
	lw t5,40(gp)
	j loop
	
	
test_3:
	lw a2,0(gp)
	lw a3,4(gp)
	addi t1,a3,0
	andi t2,a2,3
	slli t2,t2,8
	add t1,t1,t2
	andi t2,a2,124
	srli t2,t2,2
	addi t1,t1,1024
	li a5,128
	and t3,a2,a5
	#t1是已经加了1的f，t2是位移之后的e,t3是没有位移的符号位
	li t6,25
	sub t4,t6,t2
	bge t4,zero,shift_right_3  #右移
	sub t4,t2,t6
	sll t5,t1,t4
	j out_1
	
shift_right_3:
	srl t5,t1,t4
	li t6,32
	sub s1,t6,t4
	sll s0,t1,s1
	beq s0,zero,out_1
	li t6,1
	addi t4,t4,-1
	sll t6,t6,t4
	and s2,t1,t6
	addi t4,t4,1
	beq s2,zero,test_3_down
	j test_3_up
	
test_3_down:
	beq t3,zero,positive_2_2
	sub t5,zero,t5
	lw t5,40(gp)
	j loop
	
test_3_up:
	beq t3,zero,positive_1_2
	addi t5,t5,1
	sub t5,zero,t5
	lw t5,40(gp)
	j loop
	

test_4:
	lw a2,0(gp)
	lw a3,4(gp)
	add t1,a2,a3
	srli t2,t1,8
	beq t2,zero,inverse_num
	add t1,t1,t2
	j inverse_num
	
inverse_num:
	li t3,-1
	xor t1,t1,t3
	sw t3,12(gp)
	j loop
	

test_5:
	lw a2,0(gp)
	lw a3,4(gp)
	li t1,15
	and t2,t1,a2
	slli a3,a3,24
	slli t2,t2,8
	and t2,a3,t2
	sw t2,40(gp)
	j loop


test_6:
	lw a2,0(gp)
	li t6,0

loop_6:
	addi t3,a1,0
	addi t4,t5,0
	li t5,0
	addi a1,t6,0
	jal fib
	addi t6,t6,1
	blt a1,a2,loop_6
	lw t4,40(gp)
	j loop
	
fib:
	addi sp, sp, -12 # adjust stack for 2 items
	sw ra, 4(sp)     # save the return address
	sw a1, 0(sp)     # save the argument n
	addi t5,t5,2
	slti t0, a1, 2   # test for n < 2
	beq t0, zero, L1 # if n >= 2, go to L1
	addi a1, zero, 1 # else return 1
	addi sp, sp, 12  # pop 2 items off stack
	addi t5,t5,3
	jr ra            # return to caller
L1:
	addi a1, a1, -1  # n >= 2; argument gets(n-1)
	jal fib          # call fib(n-1)
	sw a1, 8(sp)     # save result for fib(n-1)
	addi t5,t5,1
	lw a1, 0(sp)     # load n
	addi a1, a1, -2  # n >= 2; argument gets(n-2)
	jal fib          # call fib(n-2)
	lw t1, 8(sp)     # restore fib(n-1)
	add a1, a1, t1   # ao = fib(n-1) + fib(n-2)
	lw ra, 4(sp)     # restore the return address
	lw t1, 8(sp)     # restore fib(n-1)
	addi sp, sp, 12  # adjust stack pointer to pop 2 items
	addi t5,t5,3
	jr ra            # return to the caller

	
test_7:
	lw a2,0(gp)
	li t6,0
	
loop_7:
	addi t3,a1,0
	addi t4,t5,0
	addi a1,t6,0
	jal fib_7
	addi t6,t6,1
	blt a1,a2,loop_7
	j loop
	
fib_7:
	addi sp, sp, -12 # adjust stack for 2 items
	sw ra, 4(sp)     # save the return address
	sw a1, 0(sp)     # save the argument n
	sw a1,40(gp)
	jal stop
	slti t0, a1, 2   # test for n < 2
	beq t0, zero, L1_7 # if n >= 2, go to L1
	addi a1, zero, 1 # else return 1
	addi sp, sp, 12  # pop 2 items off stack
	jr ra            # return to caller
L1_7:
	addi a1, a1, -1  # n >= 2; argument gets(n-1)
	jal fib_7          # call fib(n-1)
	sw a1, 8(sp)     # save result for fib(n-1)
	sw a1,40(gp)
	jal stop
	lw a1, 0(sp)     # load n
	addi a1, a1, -2  # n >= 2; argument gets(n-2)
	jal fib_7         # call fib(n-2)
	lw t1, 8(sp)     # restore fib(n-1)
	add a1, a1, t1   # ao = fib(n-1) + fib(n-2)
	lw ra, 4(sp)     # restore the return address
	lw t1, 8(sp)     # restore fib(n-1)
	addi sp, sp, 12  # adjust stack pointer to pop 2 items
	jr ra            # return to the caller
	
stop:
	li t5,10000000
	li t4,0
	j stop_1
stop_1:
	nop
	nop
	addi t4,t4,1
	ble t4,t5,stop_1
	jr ra