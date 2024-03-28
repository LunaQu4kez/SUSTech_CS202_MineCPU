module IF_ID (
    input               clk, rst,
    input [31:0]        inst_in, pc_in,
    output [31:0]       inst_out, pc_out
);

    reg [31:0] inst = 0;
    reg [31:0] pc = 0;
    assign inst_out = inst;
    assign pc_out = pc;

    always @(posedge clk) begin
        inst <= inst_in;
        pc <= pc_in;
    end


    
endmodule