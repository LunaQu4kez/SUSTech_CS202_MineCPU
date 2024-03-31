`include "Const.svh"

module Control(
    input  [`OP_WID]    inst, 
    output [`CTRL_WID]  total_ctrl,
    output IF_flush
);

    // atom ctrl wire
    logic [`ALUOP_WID] ALUOp;
    logic ALUSrc;
    logic MemWrite;
    logic MemRead;
    logic RegWrite;
    logic MemtoReg;

    // stage ctrl wire
    logic [`EX_CTRL_WID]  EX_ctrl;
    logic [`MEM_CTRL_WID] MEM_ctrl;
    logic [`WB_CTRL_WID]  WB_ctrl;
    assign EX_ctrl = {ALUOp, ALUSrc};
    assign MEM_ctrl = {MemWrite, MemRead};
    assign WB_ctrl = {RegWrite, MemtoReg}; 

    // total control
    assign total_ctrl = {EX_ctrl, MEM_ctrl, WB_ctrl};

endmodule