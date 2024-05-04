`include "Const.svh"

module Stage_IF (
    input                    clk, rst,
    input  logic [`DATA_WID] new_pc,
    input  logic             predict_fail,
    output logic [`DATA_WID] pc_out,
    output logic [`DATA_WID] inst,
    output logic             icache_stall,
    // interact with Memory
    input  logic [`DATA_WID] mem_inst,
    output logic [`DATA_WID] mem_pc
);

    assign pc_out = new_pc;

    ICache icache_inst (
        .clk,
        .rst,
        .addr(new_pc),
        .inst,
        .predict_fail,
        .icache_stall,
        .mem_inst,
        .mem_pc
    );

endmodule
