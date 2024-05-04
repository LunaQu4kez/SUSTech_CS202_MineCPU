`include "Const.svh"

module IF_ID (
    input              clk, rst,
    input              icache_stall,
    input              dcache_stall,
    input  [`DATA_WID] inst_in, pc_in,
    output [`DATA_WID] inst_out, pc_out
);

    reg [`DATA_WID] inst = 0;
    reg [`DATA_WID] pc = 0;
    assign inst_out = inst;
    assign pc_out = pc;

    always_ff @(posedge clk) begin
        if (rst) begin
            inst <= 0;
            pc <= 0;
        end else if (dcache_stall | icache_stall) begin
            inst <= inst;
            pc <= pc;
        end else begin
            inst <= inst_in;
            pc <= pc_in;
        end
    end

endmodule
