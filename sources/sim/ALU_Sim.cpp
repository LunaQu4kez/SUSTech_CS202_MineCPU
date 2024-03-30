#include <verilated.h>
#include <cstdio>
#include <random>
#include "VALU.h"

const int SIM_TIME = 10000;
const int ALU_OPS = 10;
const int MAX_VAL = 1 << 30;
const char* ALU_OP_NAMES[ALU_OPS] = {"AND", "OR", "XOR", "ADD", "SUB", "SLL", "SRL", "SRA", "SLT", "SLTU"};
std::random_device seed;
std::ranlux48 engine(seed());
std::uniform_int_distribution<> src_num(-MAX_VAL, MAX_VAL);
std::uniform_int_distribution<> alu_op(0, ALU_OPS - 1);
VerilatedContext* contextp = new VerilatedContext;

int main(int argc, char** argv) {
    contextp->commandArgs(argc, argv);
    VALU* alu = new VALU{contextp};
    int time = 0, result;
    while (time < SIM_TIME) {
        alu->ALU_op = alu_op(engine);
        alu->src1   = src_num(engine);
        alu->src2   = src_num(engine);
        switch (alu->ALU_op) {
            case 0: result = ((uint32_t) alu->src1) & ((uint32_t) alu->src2); break;
            case 1: result = ((uint32_t) alu->src1) | ((uint32_t) alu->src2); break;
            case 2: result = ((uint32_t) alu->src1) ^ ((uint32_t) alu->src2); break;
            case 3: result = alu->src1 + alu->src2; break;
            case 4: result = alu->src1 - alu->src2; break;
            case 5: alu->src2 = alu->src2 % 32; result = ((uint32_t) alu->src1) << alu->src2; break;
            case 6: alu->src2 = alu->src2 % 32; result = ((uint32_t) alu->src1) >> alu->src2; break;
            case 7: alu->src2 = alu->src2 % 32; result = ((int32_t)  alu->src1) >> alu->src2; break;
            case 8: result = ((int32_t) alu->src1) < ((int32_t) alu->src2); break;
            case 9: result = ((uint32_t) alu->src1) < ((uint32_t) alu->src2); break;
        }
        alu->eval();
        if (alu->result != result) {
            printf("src1: %d, src2: %d, ALU_op: %s, result: %d\n", alu->src1, alu->src2, ALU_OP_NAMES[alu->ALU_op], alu->result);
            printf("Expected: %d\n", result);
        }
        time++;
    }
    alu->final();
    delete alu;

    return 0;
}
