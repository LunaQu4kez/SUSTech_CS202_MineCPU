`include "Const.svh"

module EX_MEM (
    input               clk, rst,
    input  [31:0]       pc_in, ALUres_in, data2_in,
    input               zero_in,
    input  [4:0]        inst_piece2_in,
    output [31:0]       pc_out, ALUres_out, data2_out,
    output              zero_out,
    output [4:0]        inst_piece2_out,
    // Control related
    input  [`MEM_CTRL_WID] MEM_ctrl_in,
    input  [`WB_CTRL_WID]  WB_ctrl_in,
    output [`MEM_CTRL_WID] MEM_ctrl_out,
    output [`WB_CTRL_WID]  WB_ctrl_out
);

    reg [31:0] pc = 0;
    reg [31:0] ALUres = 0;
    reg [31:0] data2 = 0;
    reg zero = 0;
    reg [4:0] inst_piece2 = 0;
    reg [`MEM_CTRL_WID] MEM_ctrl = 0;
    reg [`WB_CTRL_WID]  WB_ctrl = 0;
    assign pc_out = pc;
    assign ALUres_out = ALUres;
    assign data2_out = data2;
    assign zero_out = zero;
    assign inst_piece2_out = inst_piece2;
    assign MEM_ctrl_out = MEM_ctrl;
    assign WB_ctrl_out = WB_ctrl;

    always @(posedge clk) begin
        pc <= pc_in;
        ALUres <= ALUres_in;
        data2 <= data2_in;
        zero <= zero_in;
        inst_piece2 <= inst_piece2_in;
        MEM_ctrl <= MEM_ctrl_in;
        WB_ctrl <= WB_ctrl_in;
    end
    
endmodule