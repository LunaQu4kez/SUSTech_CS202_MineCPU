LDFLAGS := -lunicorn -lSDL2
export LDFLAGS

TARGET := Top
VERILATOR_FLAGS :=  --cc --vpi --build -j 0 -Wall -Wno-ALWCOMBORDER -Wno-UNUSEDSIGNAL --unroll-count 2048 --trace

.PHONY: all
all: obj_dir_$(TARGET)/V$(TARGET)

obj_dir_$(TARGET)/V$(TARGET): ../sources/$(TARGET).sv DiffTest.cpp
	verilator $(VERILATOR_FLAGS) -I../sources/core -I../sources/io --Mdir ./obj_dir_$(TARGET) ../sources/$(TARGET).sv --exe DiffTest.cpp

.PHONY: test
test: all
	./obj_dir_$(TARGET)/V$(TARGET)

.PHONY: clean
clean:
	rm -rf obj_dir_*
	rm *.vcd
