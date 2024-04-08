`include "Const.svh"

module IF_ID (
    input                   clk, rst,
    input                   IF_ID_Write,        // data hazard stall, 1 yes, 0 no
    input                   flush,              // control hazard flush, 1 yes, 0 no
    input  [`DATA_WID]      inst_in, pc_in,
    output [`DATA_WID]      inst_out, pc_out
);

    reg [`DATA_WID] inst = 0;
    reg [`DATA_WID] pc = -4;
    assign inst_out = inst;
    assign pc_out = pc;

    always @(posedge clk) begin
        if (rst | flush) begin
            inst <= 0;
            pc <= 0;
        end
        else begin
            inst <= (IF_ID_Write == 1'b1) ? inst : inst_in;
            pc <= (IF_ID_Write == 1'b1) ? pc : pc_in;
        end
    end

endmodule