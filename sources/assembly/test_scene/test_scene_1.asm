.data
num:.word 

.text
li t4,1
loop:
li a7,5
ecall
mv a1,a0
li a7,6
ecall
mv a2,a0
li a7,7
ecall
mv a3,a0
lw t5,20(gp)
bne t5,t4,loop

li t1,0
beq a1,t1,test_0
addi t1,t1,1
beq a1,t1,test_1
addi t1,t1,1
beq a1,t1,test_2
addi t1,t1,1
beq a1,t1,test_3
addi t1,t1,1
beq a1,t1,test_4
addi t1,t1,1
beq a1,t1,test_5
addi t1,t1,1
beq a1,t1,test_6
addi t1,t1,1
beq a1,t1,test_7
addi t1,t1,1


test_0:
mv a0,a2
li a7,1
ecall
mv a0,a3
li a7,2
ecall

test_1:
lb a0,4(gp)
li a7,3
ecall
la t3,num
sw a0,0(t3)

test_2:
lb a0,8(gp)
li a7,3
ecall
la t3,num
sw a0,4(t3)

test_3:
la t3,num
lw t1,0(t3)
lw t1,4(t3)
beq t1,t2,led_on
j led_off


test_4:
la t3,num
lw t1,0(t3)
lw t1,4(t3)
blt t1,t2,led_on
j led_off

test_5:
la t3,num
lw t1,0(t3)
lw t1,4(t3)
bge t1,t2,led_on
j led_off

test_6:
la t3,num
lw t1,0(t3)
lw t1,4(t3)
bltu t1,t2,led_on
j led_off

test_7:
la t3,num
lw t1,0(t3)
lw t1,4(t3)
bgeu t1,t2,led_on
j led_off

led_on:
li t6,1
sw t6,12(gp)
j loop

led_off:
li t6,0
sw t6,12(gp)
j loop


