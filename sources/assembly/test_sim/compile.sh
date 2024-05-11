riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o test.o $1.asm
riscv64-unknown-elf-objcopy -O binary test.o $1.bin
rm test.o
