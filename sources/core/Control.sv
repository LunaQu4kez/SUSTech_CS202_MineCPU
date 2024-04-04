`include "Const.svh"

module Control (
    input  logic [`DATA_WID] inst, 
    output logic [`CTRL_WID] total_ctrl,
    output logic             branch, predict, ujtype
);

    // atom ctrl wire
    logic [`ALUOP_WID] ALUOp;
    logic ALUSrc;       // 1: imm, 0: reg
    logic MemWrite;     // 1: write to memory, 0: no write
    logic MemRead;      // 1: read from memory, 0: no read
    logic RegWrite;     // 1: write to regs, 0: no write
    logic MemtoReg;     // 1: data from memory to regs, 0: ALU res to regs

    // stage ctrl wire
    logic [`EX_CTRL_WID]  EX_ctrl;
    logic [`MEM_CTRL_WID] MEM_ctrl;
    logic [`WB_CTRL_WID]  WB_ctrl;

    // part control signal
    assign EX_ctrl  = {ALUOp, ALUSrc};
    assign MEM_ctrl = {MemWrite, MemRead};
    assign WB_ctrl  = {RegWrite, MemtoReg};

    // total control
    assign total_ctrl = {EX_ctrl, MEM_ctrl, WB_ctrl};

    always_comb begin : Ctrl_Signal_Gen
        unique case (inst[`OP_WID])
            `ART_LOG_OP: begin
                unique case (inst[`FUNC3_WID])
                    `ADD_FUNC3: ALUOp = inst[`FUNC7_WID] ? `ALU_SUB : `ALU_ADD;
                    `SLL_FUNC3: ALUOp = `ALU_SLL;
                    `SLT_FUNC3: ALUOp = `ALU_SLT;
                   `SLTU_FUNC3: ALUOp = `ALU_SLTU;
                    `XOR_FUNC3: ALUOp = `ALU_XOR;
                    `SRL_FUNC3: ALUOp = inst[`FUNC7_WID] ? `ALU_SRA : `ALU_SRL;
                     `OR_FUNC3: ALUOp = `ALU_OR;
                    `AND_FUNC3: ALUOp = `ALU_AND;
                       default: ALUOp = 0;
                endcase
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                branch   = 0;
                predict  = 0;
            end
            `ART_IMM_OP: begin
                unique case (inst[`FUNC3_WID])
                    `ADD_FUNC3: ALUOp = `ALU_ADD;
                    `SLL_FUNC3: ALUOp = `ALU_SLL;
                    `SLT_FUNC3: ALUOp = `ALU_SLT;
                   `SLTU_FUNC3: ALUOp = `ALU_SLTU;
                    `XOR_FUNC3: ALUOp = `ALU_XOR;
                    `SRL_FUNC3: ALUOp = inst[`FUNC7_WID] ? `ALU_SRA : `ALU_SRL;
                     `OR_FUNC3: ALUOp = `ALU_OR;
                    `AND_FUNC3: ALUOp = `ALU_AND;
                       default: ALUOp = 0;
                endcase
                ALUSrc   = 1;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 1;
                MemtoReg = 0;
                branch   = 0;
                predict  = 0;
            end
            `LOAD_OP: begin
                ALUOp    = `ALU_ADD;
                ALUSrc   = 1;
                MemWrite = 0;
                MemRead  = 1;
                RegWrite = 1;
                MemtoReg = 1;
            end
            `STORE_OP: begin
                ALUOp    = `ALU_ADD;
                ALUSrc   = 1;
                MemWrite = 1;
                MemRead  = 0;
                RegWrite = 0;
                MemtoReg = 0;
            end
            `BRANCH_OP: begin
                ALUOp    = `ALU_ADD;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                RegWrite = 0;
                MemtoReg = 0;
            end
            `JALR_OP: begin
                ALUOp = `ALU_ADD;
                ALUSrc = 1;
                MemWrite = 0;
                MemRead = 0;
                RegWrite = 1;
                MemtoReg = 0;
            end
            `JAL_OP: begin
                ALUOp = `ALU_ADD;
                ALUSrc = 1;
                MemWrite = 0;
                MemRead = 0;
                RegWrite = 1;
                MemtoReg = 0;
            end
            `LUI_OP: begin
                ALUOp = `ALU_ADD;
                ALUSrc = 1;
                MemWrite = 0;
                MemRead = 0;
                RegWrite = 1;
                MemtoReg = 0;
            end
            `AUIPC_OP: begin
                ALUOp = `ALU_ADD;
                ALUSrc = 1;
                MemWrite = 0;
                MemRead = 0;
                RegWrite = 1;
                MemtoReg = 0;
            end
            default: begin
                ALUOp = 0;
                ALUSrc = 0;
                MemWrite = 0;
                MemRead = 0;
                RegWrite = 0;
                MemtoReg = 0;
            end
        endcase
    end

endmodule