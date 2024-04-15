// Bus Widths
`define DATA_WID    31:0
`define FUNC3_WID   14:12
`define FUNC7_WID   31:25
`define REGS_WID     4:0
`define OP_WID       6:0
`define ALUOP_WID    3:0
`define ALUSRC_WID   1:0
`define BRUOP_WID    2:0
`define FW_WID       1:0
`define CTRL_WID    15:0
`define EX_CTRL_WID  8:0
`define MEM_CTRL_WID 4:0
`define WB_CTRL_WID  1:0
`define LDST_WID     2:0

// Opcode
`define ART_LOG_OP 7'b0110011  // R type
`define ART_IMM_OP 7'b0010011  // I type
`define LOAD_OP    7'b0000011  // I type
`define STORE_OP   7'b0100011  // S type for sb, sh, sw, I type for sd
`define BRANCH_OP  7'b1100011  // B type (SB type)
`define JALR_OP    7'b1100111  // I type
`define JAL_OP     7'b1101111  // J type (UJ type)
`define LUI_OP     7'b0110111  // U type
`define AUIPC_OP   7'b0010111  // U type
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
// Funct3 list
`define ADD_FUNC3  3'b000
`define SLL_FUNC3  3'b001
`define SLT_FUNC3  3'b010
`define SLTU_FUNC3 3'b011
`define XOR_FUNC3  3'b100
`define SRL_FUNC3  3'b101
`define OR_FUNC3   3'b110
`define AND_FUNC3  3'b111
`define BEQ_FUNC3  3'b000
`define BNE_FUNC3  3'b001
`define BLT_FUNC3  3'b100
`define BGE_FUNC3  3'b101
`define BLTU_FUNC3 3'b110
`define BGEU_FUNC3 3'b111
`define LB_FUNC3   3'b000
`define LH_FUNC3   3'b001
`define LW_FUNC3   3'b010
`define LBU_FUNC3  3'b100
`define LHU_FUNC3  3'b101
`define SB_FUNC3   3'b000
`define SH_FUNC3   3'b001
`define SW_FUNC3   3'b010
// Branch Control lines
`define BRU_NOP    3'b000
`define BRU_EQ     3'b001
`define BRU_NE     3'b010
`define BRU_LT     3'b011
`define BRU_GE     3'b100
`define BRU_LTU    3'b101
`define BRU_GEU    3'b110
`define BRU_JMP    3'b111
// Load Store op
`define LB_OP      3'b000
`define LH_OP      3'b001
`define LW_OP      3'b010
`define LBU_OP     3'b011
`define LHU_OP     3'b100
`define SB_OP      3'b101
`define SH_OP      3'b110
`define SW_OP      3'b111
// Address and gp register
`define MMIO_ADDR  32'hffffff00
`define STAK_ADDR  32'h00007ffc
