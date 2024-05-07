`include "Const.svh"

module IF_ID (
    input              clk, rst,
    input              icache_stall,
    input              dcache_stall,
    input              IF_ID_Write,
    input              predict_fail,
    input              predict_in,
    input  [`DATA_WID] predict_pc_in,
    input  [`DATA_WID] inst_in, pc_in,
    output [`DATA_WID] inst_out, pc_out,
    output             predict_out,
    output [`DATA_WID] predict_pc_out
);

    reg [`DATA_WID] inst = 0;
    reg [`DATA_WID] pc = 0;
    reg [`DATA_WID] predict_pc = 0;
    reg predict = 0;
    assign inst_out = inst;
    assign pc_out = pc;
    assign predict_out = predict;
    assign predict_pc_out = predict_pc;

    always_ff @(posedge clk) begin
        if (rst | (icache_stall && !dcache_stall) | predict_fail) begin
            inst <= 0;
            pc <= 0;
            predict <= 0;
            predict_pc <= 0;
        end else if (dcache_stall | IF_ID_Write) begin
            inst <= inst;
            pc <= pc;
            predict <= predict;
            predict_pc <= predict_pc;
        end else begin
            inst <= inst_in;
            pc <= pc_in;
            predict <= predict_in;
            predict_pc <= predict_pc_in;
        end
    end

endmodule
