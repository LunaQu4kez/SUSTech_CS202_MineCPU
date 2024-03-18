module MEM_WB (
    input               clk, rst,
    input [31:0]        addr_in, data_in,
    input [4:0]         inst_piece2_in,
    output [31:0]       addr_out, data_out,
    output [4:0]        inst_piece2_out
);

    reg [31:0] addr = 0;
    reg [31:0] data = 0;
    reg [4:0] inst_piece2 = 0;
    assign addr_out = addr;
    assign data_out = data;
    assign inst_piece2_out = inst_piece2;

    always @(posedge clk) begin
        addr <= addr_in;
        data <= data_in;
        inst_piece2 <= inst_piece2_in;
    end
    
endmodule