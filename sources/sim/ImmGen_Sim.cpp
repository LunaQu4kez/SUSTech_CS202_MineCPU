#include <verilated.h>
#include <iostream>
#include <bitset>
#include <random>
#include "VImmGen.h"
using namespace std;

const int SIM_TIME = 1e6;
const int OP_NUMS = 9;
const int MAX_VAL = (1 << 26) - 1;
const int OP_CODES[OP_NUMS] = {51, 19, 3, 35, 99, 103, 111, 55, 23};
const string OP_NAMES[OP_NUMS] = {"R-type", "I-type", "I-type", "S-type", "B-type", "I-type", "J-type", "U-type", "U-type"};
std::random_device seed;
std::ranlux48 engine(seed());
std::uniform_int_distribution<> inst_res(0, MAX_VAL);
std::uniform_int_distribution<> inst_op(0, OP_NUMS - 1);
VerilatedContext* contextp = new VerilatedContext;

unsigned int itype(int inst) {
	unsigned int imm = (inst >> 20) & 0xfff;
	if (imm & 0x800) imm |= 0xfffff000;
	return imm;
}

unsigned int stype(int inst) {
	unsigned int imm = ((inst >> 25) << 5) | ((inst >> 7) & 0x1f);
	if (imm & 0x800) imm |= 0xfffff000;
	return imm;
}

unsigned int btype(int inst) {
	bitset<32> bits(inst), res(0);
	res[12] = bits[31];
	for(int i = 5; i <= 10; i++) res[i] = bits[i + 20];
	for(int i = 1; i <= 4; i++) res[i] = bits[i + 7];
	res[11] = bits[7];
	for(int i = 13; i <= 31; i++) res[i] = res[12];
	return (unsigned int) res.to_ulong();
}

unsigned int utype(int inst) {
	return inst & 0xfffff000;
}

unsigned int jtype(int inst) {
	bitset<32> bits(inst), res(0);
	res[20] = bits[31];
	for(int i = 1; i <= 10; i++) res[i] = bits[i + 20];
	res[11] = bits[20];
	for(int i = 12; i <= 19; i++) res[i] = bits[i];
	for(int i = 21; i <= 31; i++) res[i] = res[20];
	return (unsigned int) res.to_ulong();
}

int main(int argc, char** argv) {
    contextp->commandArgs(argc, argv);
    VImmGen* immgen = new VImmGen{contextp};
    uint64_t time = 0, result, imm, op;
    while (time < SIM_TIME) {
		imm = inst_res(engine);
		op = inst_op(engine);
		immgen->inst = (imm << 7) + OP_CODES[op];
        switch (op) {
            case 0: result = 0; break; // R-type
            case 1: result = itype(immgen->inst); break;
            case 2: result = itype(immgen->inst); break;
            case 3: result = stype(immgen->inst); break;
            case 4: result = btype(immgen->inst); break;
            case 5: result = itype(immgen->inst); break;
            case 6: result = jtype(immgen->inst); break;
            case 7: result = utype(immgen->inst); break;
            case 8: result = utype(immgen->inst); break;
        }
        immgen->eval();
        if (immgen->imm != (unsigned int) result) {
			for(int i = 0; i < OP_NUMS; i++) if(OP_CODES[i] == (immgen->inst & 0x7f)) cout << "Op: " << OP_NAMES[i] << endl;
			cout << "inst: " << bitset<32>(immgen->inst).to_string() << endl;
			cout << "Immediate: " << bitset<32>(immgen->imm).to_string() << endl;
			cout << " Expected: " << bitset<32>(result).to_string() << endl;
			break;
        }
        time++;
    }
    immgen->final();
    delete immgen;

    return 0;
}