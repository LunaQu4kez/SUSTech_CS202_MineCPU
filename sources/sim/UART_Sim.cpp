#include <unicorn/unicorn.h>
#include <verilated.h>
#include <verilated_vpi.h>
#include "verilated_vcd_c.h"
#include <vector>
#include <fstream>
#include "VUART.h"

using std::vector;

// verilator
const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
VUART *top = new VUART(contextp.get());
VerilatedVcdC* tfp = new VerilatedVcdC;

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

void run_one_bit() {
    for(int i = 0; i < 868; i++) {
        top->clk = 1;
        top->eval();
        contextp->timeInc(1);
        tfp->dump(contextp->time());
        top->clk = 0;
        top->eval();
        contextp->timeInc(1);
        tfp->dump(contextp->time());
    }
}

void send_uart(char msg) {
    top->rx = 1;
    run_one_bit();
    top->rx = 0;
    run_one_bit();
    for(int i = 0; i < 8; i++) {
        top->rx = (msg >> i) & 1;
        run_one_bit();
    }
    top->rx = 1;
    run_one_bit();
    run_one_bit();
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    top->trace(tfp, 1);
    tfp->open("uart_sim.vcd");

    vector<char> messages = read_binary("../assembly/test/test1.bin");
    top->clk = 1;
    top->rst = 0;
    top->eval();
    contextp->timeInc(1);
    tfp->dump(contextp->time());

    for(int i = 0; i < 8; i++) {
        printf("sending message 0x%02x\n", messages[i] & 0xff);
        send_uart(messages[i]);
    }

    run_one_bit();
    top->final(), tfp->close();
    delete top;

    return 0;
}
