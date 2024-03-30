TARGET := ALU
# modify this to the name of the module you want to simulate

.PHONY: all
all: obj_dir_$(TARGET)/V$(TARGET)

obj_dir_$(TARGET)/V$(TARGET): ../core/$(TARGET).sv $(TARGET)_Sim.cpp
	verilator --cc --exe --build -j 0 -Wall -I../core --Mdir ./obj_dir_$(TARGET) ../core/$(TARGET).sv $(TARGET)_Sim.cpp

.PHONY: run
run: all
	./obj_dir_$(TARGET)/V$(TARGET)

.PHONY: clean
clean:
	rm -rf obj_dir_*
