`include "Const.svh"

module EX_MEM (
    input                  clk, rst,
    input  [`DATA_WID    ] ALUres_in, data2_in, pc_4_in,
    input  [`REGS_WID    ] rd_in,
    output [`DATA_WID    ] ALUres_out, data2_out, pc_4_out,
    output [`REGS_WID    ] rd_out,
    // Control related
    input  [`MEM_CTRL_WID] MEM_ctrl_in,
    input  [`WB_CTRL_WID ] WB_ctrl_in,
    output [`MEM_CTRL_WID] MEM_ctrl_out,
    output [`WB_CTRL_WID ] WB_ctrl_out
);

    reg [`DATA_WID] ALUres = 0;
    reg [`DATA_WID] data2 = 0;
    reg [`REGS_WID] rd = 0;
    reg [`MEM_CTRL_WID] MEM_ctrl = 0;
    reg [`WB_CTRL_WID]  WB_ctrl = 0;
    reg [`DATA_WID] pc_4 = 0;
    assign ALUres_out = ALUres;
    assign data2_out = data2;
    assign rd_out = rd;
    assign MEM_ctrl_out = MEM_ctrl;
    assign WB_ctrl_out = WB_ctrl;
    assign pc_4_out = pc_4;

    always @(posedge clk) begin
        if (rst) begin
            ALUres <= 0;
            data2 <= 0;
            rd <= 0;
            MEM_ctrl <= 0;
            WB_ctrl <= 0;
            pc_4 <= 0;
        end
        else begin
            ALUres <= ALUres_in;
            data2 <= data2_in;
            rd <= rd_in;
            MEM_ctrl <= MEM_ctrl_in;
            WB_ctrl <= WB_ctrl_in;
            pc_4 <= pc_4_in;
        end
    end
    
endmodule
