#include <unicorn/unicorn.h>
#include <verilated.h>
#include <verilated_vpi.h>
#include "verilated_vcd_c.h"
#include <vector>
#include <fstream>
#include "VCPU.h"

using std::vector;
const char *REG_NAMES[32] = {"x0", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};
const int SIM_TIME = 1000;

// verilator
const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
VCPU *top = new VCPU(contextp.get());
VerilatedVcdC* tfp = new VerilatedVcdC;

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
    top->memclk = 1;
    top->eval();
    contextp->timeInc(1);
    tfp->dump(contextp->time());
    top->cpuclk = 0;
    top->memclk = 0;
    top->eval();
    contextp->timeInc(1);
    tfp->dump(contextp->time());
}

vector<uint32_t> load_program() {
    vector<char> data = read_binary("../assembly/test_sim/test9.bin"); // modify the path to the binary file
    vector<unsigned int> inst;
    uint32_t concat_data, size = data.size() / 4;

    if (uc_mem_write(uc, 0x0, data.data(), data.size())) {
        printf("Failed to write emulation code to memory, quit!\n");
        return vector<uint32_t>();
    }

    for(int i = 0; i < size; i++) {
        concat_data = 0;
        for(int j = 3; j >= 0; j--) concat_data = (concat_data << 8) | ((data[4 * i + j]) & 0xff);
        top->uart_addr = i * 4;
        top->uart_data = concat_data;
        inst.push_back(concat_data);
        run_one_cycle();
        run_one_cycle();
    }

    return inst;
}

bool diff_check() {
    bool pass = true;
    for (int i = 0, v; i < 32; i++) {
        uc_reg_read(uc, i + 1, &v);
        if (v != get_value(regs[i])) {
            pass = false;
            printf("regs: uc, cpu\n");
            printf("%4s: 0x%x, 0x%x\n", REG_NAMES[i], v, get_value(regs[i]));
        }
    }
    return pass;
}

void set_device() {
    top->switches1 = 7;
    top->switches2 = 4;
    top->bt1 = 1;
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
    uc_mem_map(uc, 0x00000000, (1 << 28) * 4, UC_PROT_ALL);
    uc_mem_map(uc, 0xffff0000, (1 << 16) * 4, UC_PROT_ALL);
    int uc_sp = 0x7ffc, uc_gp = 0xffffff00;
    uc_reg_write(uc, UC_RISCV_REG_SP, &uc_sp);
    uc_reg_write(uc, UC_RISCV_REG_GP, &uc_gp);

    // initialize vpi handles
    pc = get_handle("TOP.CPU.pc_inst.pc");
    for(int i = 0; i < 32; i++) regs[i] = vpi_handle_by_index(get_handle("TOP.CPU.id_inst.reg_inst.regs"), i);
    for(int i = 0; i < 16383; i++) mem[i] = vpi_handle_by_index(get_handle("TOP.CPU.memory_inst.test_inst.mem"), i);

    long long time = 0, uc_pc = 0;

    // load program
    top->rst_n = 1;
    top->uart_done = 0;
    vector<uint32_t> inst = load_program();
    top->uart_done = 1;

    while (uc_pc != inst.size() * 4){
        if(time++ > SIM_TIME) break;
        if(time == 100) set_device();
        run_one_cycle();
    	VerilatedVpi::callValueCbs();
        // run one instruction on unicorn
        if ((err = uc_emu_start(uc, uc_pc, 0xFFFFFFFF, 0, 1))) {
            printf("pc: 0x%llx\n", uc_pc);
            printf("Failed on uc_emu_start() with error returned %u: %s\n", err, uc_strerror(err));
            break;
        }
        uc_reg_read(uc, UC_RISCV_REG_PC, &uc_pc);
    }
    
    while(get_value(pc) <= inst.size() * 4 + 10 && time++ < SIM_TIME) run_one_cycle();

    diff_check();
    printf("pc: 0x%x\n", get_value(pc));

	top->final(), tfp->close();
    delete top;

	return 0;
}
