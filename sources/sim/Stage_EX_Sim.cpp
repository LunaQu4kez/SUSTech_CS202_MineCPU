#include <verilated.h>
#include <verilated_vpi.h>
#include <iostream>
#include "VStage_EX.h"
using namespace std;

const int SIM_TIME = 6;
const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
VStage_EX* ex_unit = new VStage_EX(contextp.get());

void read_and_check() {
      vpiHandle vh1 = vpi_handle_by_name((PLI_BYTE8*)"TOP.Stage_EX.src1", NULL);
      if (!vh1) vl_fatal(__FILE__, __LINE__, "read_and_check", "No handle found");
      const char* name = vpi_get_str(vpiName, vh1);
      const char* type = vpi_get_str(vpiType, vh1);
      const int size = vpi_get(vpiSize, vh1);
      printf("register name: %s, type: %s, size: %d\n", name, type, size);

      s_vpi_value v;
      v.format = vpiIntVal;
      vpi_get_value(vh1, &v);
      printf("Value of %s: %d\n", name, v.value.integer);
  }

int main(int argc, char** argv) {
	Verilated::commandArgs(argc, argv);
	uint64_t time = 0;
	contextp->internalsDump();

	while (time < 1) {
		ex_unit->eval();
		VerilatedVpi::callValueCbs();
        read_and_check();
		time++;
	}
	ex_unit->final();
	
	return 0;
}