// Bus Widths
`define DATA_WID   31:0
`define REGS_WID    4:0
`define OP_WID      6:0
`define ALUOP_WID   3:0
`define FW_WID      1:0
// Opcode
`define ART_LOG_OP 7'b0110011
`define ART_IMM_OP 7'b0010011
`define LOAD_OP    7'b0000011
`define STORE_OP   7'b0100011
`define BRANCH_OP  7'b1100011
`define JALR_OP    7'b1100111
`define JAL_OP     7'b1101111
`define LUI_OP     7'b0110111
`define AUIPC_OP   7'b0010111
// ALU Control lines
`define ALU_AND    4'b0000
`define ALU_OR     4'b0001
`define ALU_XOR    4'b0010
`define ALU_ADD    4'b0011
`define ALU_SUB    4'b0100
`define ALU_SLL    4'b0101
`define ALU_SRL    4'b0110
`define ALU_SRA    4'b0111
`define ALU_SLT    4'b1000
`define ALU_SLTU   4'b1001
