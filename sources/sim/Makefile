LDFLAGS := -lunicorn -lSDL2
export LDFLAGS

TARGET := CPU
# modify this to the name of the module you want to simulate

.PHONY: all
all: obj_dir_$(TARGET)/V$(TARGET)

obj_dir_$(TARGET)/V$(TARGET): ../core/$(TARGET).sv $(TARGET)_Sim.cpp
	verilator --cc --vpi --build -j 0 -Wall -Wno-ALWCOMBORDER -Wno-UNUSEDSIGNAL --unroll-count 2048 -I../core --Mdir ./obj_dir_$(TARGET) ../core/$(TARGET).sv --exe $(TARGET)_Sim.cpp

.PHONY: test
test: all
	./obj_dir_$(TARGET)/V$(TARGET)

.PHONY: clean
clean:
	rm -rf obj_dir_*
