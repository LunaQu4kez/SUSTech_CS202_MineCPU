`include "Const.svh"

module RegisterFile (
    input  logic             clk, rst,
    input  logic [`REGS_WID] read_reg_1, read_reg_2, write_reg,
    input  logic [`DATA_WID] write_data,
    input  logic             RegWrite,
    output logic [`DATA_WID] read_data_1, read_data_2
);
    
    reg [`DATA_WID] regs[31:0] /*verilator public*/;

    assign read_data_1 = regs[read_reg_1];
    assign read_data_2 = regs[read_reg_2];
    
    always_ff @(negedge clk, posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                regs[i] <= 0;
            end
        end 
        else if (RegWrite) begin
            regs[write_reg] <= write_data;
        end
    end
    
endmodule