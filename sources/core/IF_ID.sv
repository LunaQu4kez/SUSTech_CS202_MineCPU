`include "Const.svh"

module IF_ID (
    input                   clk, rst,
    input  [`DATA_WID]      inst_in, pc_in,
    output [`DATA_WID]      inst_out, pc_out
);

    reg [`DATA_WID] inst = 0;
    reg [`DATA_WID] pc = -4;
    assign inst_out = inst;
    assign pc_out = pc;

    always @(posedge clk) begin
        if (rst) begin
            inst <= 0;
            pc <= 0;
        end else begin
            inst <= inst_in;
            pc <= pc_in;
        end
    end

endmodule