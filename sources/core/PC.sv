`include "Const.svh"

module PC (
    input                    clk, rst,
    input  logic             PC_Write,   // hazard stall 1: yes, 0: no
    input  logic             icache_stall,
    input  logic             dcache_stall,
    input  logic [`DATA_WID] new_pc,     // next pc
    output logic [`DATA_WID] pc_out
);

    logic [`DATA_WID] pc = 0 /*verilator public*/;
    assign pc_out = pc;

    always_ff @(negedge clk) begin
        if (rst) pc <= 0;
        else pc <= (PC_Write || icache_stall || dcache_stall) ? pc : new_pc;
    end
    
endmodule
