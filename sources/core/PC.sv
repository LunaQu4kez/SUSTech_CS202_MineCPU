`include "Const.svh"

module PC (
    input              clk, rst,   // TODO: implement reset
    input              PC_Write,   // hazard stall 1: yes, 0: no
    input  [`DATA_WID] new_pc,     // next pc
    output [`DATA_WID] pc_out
);

    reg [31:0] pc /*verilator public*/;
    assign pc_out = pc;
    initial pc = 0;

    always_ff @(posedge clk) begin
        pc <= (PC_Write == 1'b0) ? new_pc : pc;
    end
    
endmodule
