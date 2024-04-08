`include "Const.svh"

module Stage_WB (
    input  logic [`WB_CTRL_WID]     WB_ctrl,
    input  logic [`DATA_WID   ]     data, ALU_res, pc_4,
    output logic [`DATA_WID   ]     write_data
);

    logic MemtoReg;           // 1: data from memory to regs, 0: ALU res to regs
    logic jal;
    assign MemtoReg = WB_ctrl[0];    
    assign jal = WB_ctrl[2];
    assign write_data = (jal == 1'b1) ? pc_4 : ((MemtoReg == 1'b1) ? data : ALU_res);

endmodule