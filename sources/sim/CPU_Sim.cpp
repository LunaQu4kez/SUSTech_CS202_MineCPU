#include <unicorn/unicorn.h>
#include <verilated.h>
#include <verilated_vpi.h>
#include "verilated_vcd_c.h"
#include <vector>
#include <fstream>
#include "VCPU.h"

using std::vector;
const char *REG_NAMES[32] = {"x0", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};
const int SIM_TIME = 7;

// verilator
const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
VCPU *top = new VCPU(contextp.get());
VerilatedVcdC* tfp = new VerilatedVcdC;

// const uint64_t inst[8] = {
//     0x00400393,
//     0x00735663,
//     0x00130313,
//     0xfe000ce3,
//     0x0061a223,
// };

// unicorn simulator
uc_engine *uc;

// vpi handles
vpiHandle pc;
vpiHandle regs[32];
vpiHandle mem[16383];

// from Monad's code
vector<char> read_binary(const char *name) {
    std::ifstream f;
    f.open(name, std::ios::binary);
    f.seekg(0, std::ios::end);
    size_t size = f.tellg();

    std::vector<char> data;
    data.resize(size);
    f.seekg(0, std::ios::beg);
    f.read(&data[0], size);
    return data;
}

vpiHandle get_handle(const char *name) {
    vpiHandle vh = vpi_handle_by_name((PLI_BYTE8*)name, NULL);
    if (vh == NULL) {
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

void run_one_cycle() {
    top->cpuclk = 1;
    top->eval();
    for(int i = 0; i < 2; i++) {
        top->memclk = 1;
        top->eval();
        contextp->timeInc(1);
        tfp->dump(contextp->time());
        top->memclk = 0;
        top->eval();
        contextp->timeInc(1);
        tfp->dump(contextp->time());
    }
    top->cpuclk = 0;
    top->eval();
    for(int i = 0; i < 2; i++) {
        top->memclk = 1;
        top->eval();
        contextp->timeInc(1);
        tfp->dump(contextp->time());
        top->memclk = 0;
        top->eval();
        contextp->timeInc(1);
        tfp->dump(contextp->time());
    }
}

size_t load_program() {
    vector<char> data = read_binary("../assembly/fib.bin");
    uint64_t concat_data, size = data.size() / 4;

    for(int i = 0; i < size; i++) {
        concat_data = 0;
        for(int j = 3; j >= 0; j--) concat_data = (concat_data << 8) | ((data[4 * i + j]) & 0xff);
        top->uart_addr = i * 4;
        top->uart_data = concat_data;
        run_one_cycle();
    }
    return size;
}

void diff_check() {
    for (int i = 0; i < 32; i++) printf("%3s: 0x%x\n", REG_NAMES[i], get_value(regs[i]));
    printf("Stack: \n");
    for (uint32_t i = 0xfaf >> 2; i < 0xfff >> 2; i++) {
        printf("mem[%d] = 0x%x\n", i, get_value(mem[i]));
    }
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    top->trace(tfp, 1);
    tfp->open("cpu_sim.vcd");

    // initialize unicorn
    uc_err err;
    if ((err = uc_open(UC_ARCH_RISCV, UC_MODE_32, &uc)) != UC_ERR_OK) {
        printf("Failed on uc_open() with error returned: %u\n", err);
        return -1;
    }
    uc_mem_map(uc, 0x0, 16384 * 4, UC_PROT_ALL);

    // initialize vpi handles
    pc = get_handle("TOP.CPU.pc_inst.pc");
    for(int i = 0; i < 32; i++) regs[i] = vpi_handle_by_index(get_handle("TOP.CPU.id_inst.reg_inst.regs"), i);
    for(int i = 0; i < 16383; i++) mem[i] = vpi_handle_by_index(get_handle("TOP.CPU.memory_inst.test_inst.mem"), i);

    long long time = 0;

    top->rst_n = 1;
    top->uart_finish = 0;
    size_t program_size = load_program();
    top->uart_finish = 1;
    // run four cycles to get warm up
    for(int i = 0; i < 3; i++) run_one_cycle();
    while (time < 100) {
        run_one_cycle();
    	VerilatedVpi::callValueCbs();
        time++;
    }
    diff_check();

	top->final(), tfp->close();
    delete top;

	return 0;
}
