CC := riscv64-unknown-elf-gcc
LD := riscv64-unknown-elf-ld
AS := riscv64-unknown-elf-as
OBJCOPY := riscv64-unknown-elf-objcopy

TARGET = test1

.PHONY: all
all: $(TARGET).bin

%.o: %.c
	$(CC) -c -march=rv32i -mabi=ilp32  -o $@ $<

%.hex: %.o
	$(LD) -m elf32lriscv  --no-warnings -T linker_script.ld -o $@ $<

$(TARGET).bin: %.bin: %.hex
	$(OBJCOPY) -O binary $< $@

.PHONY: clean
clean:
	rm *.o *.hex $(TARGET)