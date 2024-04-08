`include "Const.svh"

module MEM_WB (
    input                       clk, rst,
    input  logic [`DATA_WID   ] addr_in, data_in, pc_4_in,
    input  logic [`REGS_WID   ] rd_in,
    output logic [`DATA_WID   ] addr_out, data_out, pc_4_out,
    output logic [`REGS_WID   ] rd_out,
    // Control related
    input  logic [`WB_CTRL_WID] WB_ctrl_in,
    output logic [`WB_CTRL_WID] WB_ctrl_out
);

    reg [`DATA_WID] addr = 0;
    reg [`DATA_WID] data = 0;
    reg [`REGS_WID] rd = 0;
    reg [`WB_CTRL_WID]  WB_ctrl = 0;
    reg [`DATA_WID] pc_4 = 0;
    assign addr_out = addr;
    assign data_out = data;
    assign rd_out = rd;
    assign WB_ctrl_out = WB_ctrl;
    assign pc_4_out = pc_4;

    always @(posedge clk) begin
        if (rst) begin
            addr <= 0;
            data <= 0;
            rd <= 0;
            WB_ctrl <= 0;
            pc_4 <= 0;
        end
        else begin
            addr <= addr_in;
            data <= data_in;
            rd <= rd_in;
            WB_ctrl <= WB_ctrl_in;
            pc_4 <= pc_4_in;
        end
    end
    
endmodule