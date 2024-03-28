module PC (
    input           clk, rst,  // toDo: implement reset
    input [31:0]    pc_in,
    output [31:0]   pc_out
);

    reg [31:0] pc = 0;
    assign pc_out = pc;

    always @(posedge clk) begin
        pc <= pc_in;
    end
    
endmodule