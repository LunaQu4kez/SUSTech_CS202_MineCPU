#include <unicorn/unicorn.h>
#include <verilated.h>
#include <verilated_vpi.h>
#include <random>
#include "VMemory.h"

const char* LDST_OP[8] = {"lb", "lh", "lw", "lbu", "lhu", "sb", "sh", "sw"};
const int SIM_TIME = 20;
const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
uc_engine *uc;
vpiHandle vpi_mem[16384];

vpiHandle get_handle(const char *name) {
    vpiHandle vh = vpi_handle_by_name((PLI_BYTE8*)name, NULL);
    if (vh != NULL) {
        printf("name: %s\n", name);
        vl_fatal(__FILE__, __LINE__, "get_handle", "No handle found");
    }
    return vh;
}

int get_value(vpiHandle vh) {
	s_vpi_value v; v.format = vpiIntVal;
	vpi_get_value(vh, &v);
	return v.value.integer;
}

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);
	uc_err err; int time = 0, clock = 0;
    if ((err = uc_open(UC_ARCH_RISCV, UC_MODE_32, &uc)) != UC_ERR_OK) {
        printf("Failed on uc_open() with error returned: %u\n", err);
        return -1;
    }

	uc_mem_map(uc, 0, 2 * 1024, UC_PROT_ALL);
	for (int i = 0; i < 5; i++) {
        char buffer[64];
        snprintf(buffer, 64, "TOP.Memory.test_inst.mem%d", i);
        vpi_mem[i] = get_handle(buffer);
    }

	while(time < SIM_TIME) {
    	VerilatedVpi::callValueCbs();
		time++;
	}
	
	return 0;
}