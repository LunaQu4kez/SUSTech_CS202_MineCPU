`include "Const.svh"

module PC (
    input                   clk, rst,       // toDo: implement reset
    input                   PC_Write,       // data adventure stall, 1 yes, 0 no
    input  [`DATA_WID]      pc_branch_n,
    input  [`DATA_WID]      pc_branch_y,
    input                   branch,         // 1 jump branch, 0 do not jump(pc = pc + 4)
    output [`DATA_WID]      pc_out
);

    reg [31:0] pc /*verilator public*/;
    assign pc_out = pc;
    initial begin pc = 0; end

    always @(posedge clk) begin
        pc <= (PC_Write == 1'b0) ? (branch == 1'b0 ? pc_branch_n : pc_branch_y) : pc;
    end
    
endmodule