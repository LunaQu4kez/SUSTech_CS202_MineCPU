`include "Const.svh"

module IF_ID (
    input                   clk, rst,
    input                   IF_ID_Write,        // data adventure stall, 1 yes, 0 no
    input                   IF_Flush,           // control adventure flush, 1 yes, 0 no
    input  [`DATA_WID]      inst_in, pc_in,
    output [`DATA_WID]      inst_out, pc_out
);

    reg [31:0] inst = 0;
    reg [31:0] pc = 0;
    assign inst_out = inst;
    assign pc_out = pc;

    always @(posedge clk) begin
        inst <= (IF_ID_Write == 1'b0 & IF_Flush == 1'b0) ? inst_in : inst;
        pc <= (IF_ID_Write == 1'b0 & IF_Flush == 1'b0) ? pc_in : pc;
    end

endmodule