LDFLAGS := -lunicorn -lSDL2
export LDFLAGS

SOURCE_DIR := ../io
TARGET := UART
VERILATOR_FLAGS :=  --cc --vpi --build -j 0 -Wall -Wno-ALWCOMBORDER -Wno-UNUSEDSIGNAL --unroll-count 2048 --trace
# modify this to the name of the module you want to simulate

.PHONY: all
all: obj_dir_$(TARGET)/V$(TARGET)

obj_dir_$(TARGET)/V$(TARGET): $(SOURCE_DIR)/$(TARGET).sv $(TARGET)_Sim.cpp
	verilator $(VERILATOR_FLAGS) -I$(SOURCE_DIR) --Mdir ./obj_dir_$(TARGET) $(SOURCE_DIR)/$(TARGET).sv --exe $(TARGET)_Sim.cpp

.PHONY: test
test: all
	./obj_dir_$(TARGET)/V$(TARGET)

.PHONY: clean
clean:
	rm -rf obj_dir_*
	rm *.vcd
