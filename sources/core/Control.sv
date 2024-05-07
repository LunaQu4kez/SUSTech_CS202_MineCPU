`include "Const.svh"

module Control (
    input  logic [`DATA_WID] inst, 
    output logic [`CTRL_WID] total_ctrl
);

    // atom ctrl wire
    logic Jalr;
    logic [`ALUOP_WID]  ALUOp;
    logic [`BRUOP_WID]  BRUOp;
    logic [`ALUSRC_WID] ALUSrc;       // 1: imm, 0: reg
    logic [`LDST_WID]   MEMOp;
    logic MemWrite;     // 1: write to memory, 0: no write
    logic MemRead;      // 1: read from memory, 0: no read
    logic RegWrite;     // 1: write to regs, 0: no write
    logic MemtoReg;     // 1: data from memory to regs, 0: ALU res to regs

    // stage ctrl wire
    logic [`EX_CTRL_WID]  EX_ctrl;
    logic [`MEM_CTRL_WID] MEM_ctrl;
    logic [`WB_CTRL_WID]  WB_ctrl;

    // part control signal
    assign EX_ctrl  = {Jalr, BRUOp, ALUOp, ALUSrc};
    assign MEM_ctrl = {MEMOp, MemWrite, MemRead};
    assign WB_ctrl  = {RegWrite, MemtoReg};

    // total control
    assign total_ctrl = {EX_ctrl, MEM_ctrl, WB_ctrl};

    // control signal generate
    always_comb begin : Ctrl_Signal_Gen
        unique case (inst[`OP_WID])
            `ART_LOG_OP: begin
                if (inst[`FUNC7_WID] == 7'h10) begin
                    unique case (inst[`FUNC3_WID])
                        `MUL_FUNC3: ALUOp = `ALU_MUL;
                       `MULH_FUNC3: ALUOp = `ALU_MULH;
                     `MULHSU_FUNC3: ALUOp = `ALU_MULHSU;
                      `MULHU_FUNC3: ALUOp = `ALU_MULHU;
                        `DIV_FUNC3: ALUOp = `ALU_DIV;
                        `REM_FUNC3: ALUOp = `ALU_REM;
                           default: ALUOp = 0;
                    endcase
                end
                else begin
                    unique case (inst[`FUNC3_WID])
                        `ADD_FUNC3: ALUOp = inst[`FUNC7_WID] == 7'h20 ? `ALU_SUB : `ALU_ADD;
                        `SLL_FUNC3: ALUOp = `ALU_SLL;
                        `SLT_FUNC3: ALUOp = `ALU_SLT;
                       `SLTU_FUNC3: ALUOp = `ALU_SLTU;
                        `XOR_FUNC3: ALUOp = `ALU_XOR;
                        `SRL_FUNC3: ALUOp = inst[`FUNC7_WID] == 7'h20 ? `ALU_SRA : `ALU_SRL;
                         `OR_FUNC3: ALUOp = `ALU_OR;
                        `AND_FUNC3: ALUOp = `ALU_AND;
                           default: ALUOp = 0;
                    endcase
                end
                BRUOp    = `BRU_NOP;
                Jalr     = 0;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            `ART_IMM_OP: begin
                unique case (inst[`FUNC3_WID])
                    `ADD_FUNC3: ALUOp = `ALU_ADD;
                    `SLL_FUNC3: ALUOp = `ALU_SLL;
                    `SLT_FUNC3: ALUOp = `ALU_SLT;
                   `SLTU_FUNC3: ALUOp = `ALU_SLTU;
                    `XOR_FUNC3: ALUOp = `ALU_XOR;
                    `SRL_FUNC3: ALUOp = inst[`FUNC7_WID] == 7'h20 ? `ALU_SRA : `ALU_SRL;
                     `OR_FUNC3: ALUOp = `ALU_OR;
                    `AND_FUNC3: ALUOp = `ALU_AND;
                       default: ALUOp = 0;
                endcase
                BRUOp    = `BRU_NOP;
                Jalr     = 0;
                ALUSrc   = 1;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            `LOAD_OP: begin
                ALUOp    = `ALU_ADD;
                BRUOp    = `BRU_NOP;
                Jalr     = 0;
                ALUSrc   = 1;
                MemWrite = 0;
                MemRead  = 1;
                RegWrite = 1;
                MemtoReg = 1;
                unique case (inst[`FUNC3_WID])
                    `LB_FUNC3:  MEMOp = `LB_OP;
                    `LH_FUNC3:  MEMOp = `LH_OP;
                    `LW_FUNC3:  MEMOp = `LW_OP;
                    `LBU_FUNC3: MEMOp = `LBU_OP;
                    `LHU_FUNC3: MEMOp = `LHU_OP;  
                    default:    MEMOp = 0;
                endcase
            end
            `STORE_OP: begin
                ALUOp    = `ALU_ADD;
                BRUOp    = `BRU_NOP;
                Jalr     = 0;
                ALUSrc   = 1;
                MemWrite = 1;
                MemRead  = 0;
                RegWrite = 0;
                MemtoReg = 0;
                unique case (inst[`FUNC3_WID])
                    `SB_FUNC3 : MEMOp = `SB_OP; 
                    `SH_FUNC3 : MEMOp = `SH_OP; 
                    `SW_FUNC3 : MEMOp = `SW_OP; 
                    default:    MEMOp = 0;
                endcase
            end
            `BRANCH_OP: begin
                unique case (inst[`FUNC3_WID])
                    `BEQ_FUNC3: BRUOp = `BRU_EQ;
                    `BNE_FUNC3: BRUOp = `BRU_NE;
                    `BLT_FUNC3: BRUOp = `BRU_LT;
                    `BGE_FUNC3: BRUOp = `BRU_GE;
                   `BLTU_FUNC3: BRUOp = `BRU_LTU;
                   `BGEU_FUNC3: BRUOp = `BRU_GEU;
                       default: BRUOp = `BRU_NOP;
                endcase
                ALUOp    = `ALU_ADD;
                Jalr     = 0;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 0;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            `JALR_OP: begin
                ALUOp    = `ALU_ADD;
                BRUOp    = `BRU_JMP;
                Jalr     = 1;
                ALUSrc   = 2;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            `JAL_OP: begin
                ALUOp    = `ALU_ADD;
                BRUOp    = `BRU_JMP;
                Jalr     = 0;
                ALUSrc   = 2;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            `LUI_OP: begin
                ALUOp    = `ALU_ADD;
                BRUOp    = `BRU_NOP;
                Jalr     = 0;
                ALUSrc   = 1;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            `AUIPC_OP: begin
                ALUOp    = `ALU_ADD;
                BRUOp    = `BRU_NOP;
                Jalr     = 0;
                ALUSrc   = 3;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            `ECALL_OP: begin
                ALUOp    = `ALU_ADD;
                BRUOp    = `BRU_NOP;
                Jalr     = 0;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 0;
                MemtoReg = 0;
                MEMOp    = 0;
            end
            default: begin
                ALUOp    = 0;
                BRUOp    = 0;
                Jalr     = 0;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 0;
                MemtoReg = 0;
                MEMOp    = 0;
            end
        endcase
    end

endmodule
