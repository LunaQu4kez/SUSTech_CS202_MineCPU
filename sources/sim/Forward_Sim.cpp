#include <verilated.h>
#include <iostream>
#include "VForward.h"

// Assembly code from textbook
// sub x2, x1, x3
// and x12, x2, x5
// or x13, x6, x2
// add x14, x2, x2
// sd x15, 100(x2)
// sd x2, 10(x11)

const int SIM_TIME = 6;
VerilatedContext* contextp = new VerilatedContext;
const char* FW_SEL[] = {"no fwd", "from MEM/WB", "from EX/MEM"};
const int rs1[] = {1, 2, 6, 2, 2, 11};
const int rs2[] = {3, 5, 2, 2, 15, 2};
const int ex_mem_rd[] = {0, 2, 12, 13, 14, 0};
const int mem_wb_rd[] = {0, 0, 2, 12, 13, 14};
const int ex_mem_regwrite[] = {0, 1, 1, 1, 1, 0};
const int mem_wb_regwrite[] = {0, 0, 1, 1, 1, 1};
const int fwdA[] = {0, 2, 0, 0, 0, 0};
const int fwdB[] = {0, 0, 1, 0, 0, 0};

int main(int argc, char** argv) {
	contextp->commandArgs(argc, argv);
    VForward* forward = new VForward{contextp};
	uint64_t time = 0;
	while (time < SIM_TIME) {
		forward->ID_EX_rs1 = rs1[time];
		forward->ID_EX_rs2 = rs2[time];
		forward->EX_MEM_rd = ex_mem_rd[time];
		forward->MEM_WB_rd = mem_wb_rd[time];
		forward->EX_MEM_RegWrite = ex_mem_regwrite[time];
		forward->MEM_WB_RegWrite = mem_wb_regwrite[time];
		forward->eval();
		if (forward->fwA != fwdA[time] || forward->fwB != fwdB[time]) {
			std::cout << "Time: " << time << std::endl;
			std::cout << "Expected: FwdA: " << FW_SEL[fwdA[time]] << ", FwdB: " << FW_SEL[fwdB[time]] << std::endl;
			std::cout << "     Got: FwdA: " << FW_SEL[forward->fwA] << ", FwdB: " << FW_SEL[forward->fwB] << std::endl;
			break;
		}
		time++;
	}
	forward->final();
	delete forward;
	
	return 0;
}
