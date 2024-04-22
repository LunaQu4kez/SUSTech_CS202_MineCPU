CC := riscv64-unknown-elf-gcc
LD := riscv64-unknown-elf-ld
AS := riscv64-unknown-elf-as
OBJCOPY := riscv64-unknown-elf-objcopy

TARGET = bubble

.PHONY: all
all: $(TARGET).bin

%.o: %.c
	$(CC) -c -march=rv32i -mabi=ilp32  -o $@ $<

%.hex: %.o
	$(LD) -m elf32lriscv  --no-warnings -T ../../../program/pacman/linker_script.ld -o $@ $<

$(TARGET).bin: %.bin: %.hex
	$(OBJCOPY) -O binary $< $@

# .PHONY: asm
# asm: $(TARGET).bin
# $(TARGET).bin: $(TARGET).o
# 	$(OBJCOPY) -O binary $< $@	
# $(TARGET).o: $(TARGET).asm
# 	$(AS) -march=rv32i -mabi=ilp32 -o $@ $<

.PHONY: clean
clean:
	rm *.o *.hex $(TARGET)