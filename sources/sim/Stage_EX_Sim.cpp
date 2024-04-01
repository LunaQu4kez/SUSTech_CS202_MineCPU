#include <verilated.h>
#include <verilated_vpi.h>
#include <iostream>
#include "VStage_EX.h"
using namespace std;

const int SIM_TIME = 6;
const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
VStage_EX* ex_unit = new VStage_EX(contextp.get());


int main(int argc, char** argv) {
	Verilated::commandArgs(argc, argv);
	uint64_t time = 0;

	while (time < 1) {
		ex_unit->eval();
		time++;
	}
	ex_unit->final();
	
	return 0;
}