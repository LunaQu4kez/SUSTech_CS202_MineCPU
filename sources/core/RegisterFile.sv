`include "Const.svh"

module RegisterFile (
    input  logic             clk, rst,
    input  logic [`REGS_WID] read_reg_1, read_reg_2, write_reg,
    input  logic [`DATA_WID] write_data,
    input  logic             RegWrite,
    output logic [`DATA_WID] read_data_1, read_data_2
);
    
    reg [`DATA_WID] regs[0:31] /*verilator public*/;

    initial begin
        regs[0] = 0;
        regs[1] = 0;
        regs[2] = `STAK_ADDR;  // sp
        regs[3] = `MMIO_ADDR;  // gp, base addr of IO
        for (int i = 4; i < 32; i++) begin
            regs[i] = 0;
        end
    end

    assign read_data_1 = regs[read_reg_1];
    assign read_data_2 = regs[read_reg_2];
    
    always_ff @(negedge clk) begin
        if (rst) begin
            regs[0] <= 0;
            regs[1] <= 0;
            regs[2] <= `STAK_ADDR;  // sp
            regs[3] <= `MMIO_ADDR;  // gp, base addr of IO
            for (int i = 4; i < 32; i++) begin
                regs[i] <= 0;
            end
        end 
        else if (RegWrite) begin
            if (write_reg != 0 & write_reg != 0) regs[write_reg] <= write_data;
        end
    end
    
endmodule
