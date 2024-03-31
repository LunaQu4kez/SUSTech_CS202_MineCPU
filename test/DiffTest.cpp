#include <unicorn/unicorn.h>
#include <cstdio>
#include <verilated.h>
#include <verilated_vpi.h>

const char *REG_NAMES[32] = {"x0", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};
const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
uc_engine *uc;

int main(int argc, char** argv[]) {
    contextp->commandArgs(argc, argv);

	uc_err err;
    if ((err = uc_open(UC_ARCH_RISCV, UC_MODE_32, &uc)) != UC_ERR_OK) {
        printf("Failed on uc_open() with error returned: %u\n", err);
        return -1;
    }
	
	return 0;
}
