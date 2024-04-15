`include "Const.svh"

module Stage_WB (
    input  logic [`WB_CTRL_WID] WB_ctrl,
    input  logic [`DATA_WID   ] data, ALU_res,
    output logic [`DATA_WID   ] write_data
);

    logic MemtoReg; // 1: data from memory to regs, 0: ALU res to regs
    assign MemtoReg = WB_ctrl[0];    
    assign write_data = (MemtoReg == 1'b1) ? data : ALU_res;

endmodule
