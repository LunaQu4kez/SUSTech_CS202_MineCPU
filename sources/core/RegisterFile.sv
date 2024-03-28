module RegisterFile (
    input             clk, rst,
    input      [4:0]  read_reg_1, read_reg_2, write_reg,
    input      [31:0] write_data,
    input             RegWrite,
    output reg [31:0] read_data_1, read_data_2
);
    
    reg [31:0] regs [31:0];

    always @(negedge clk) begin
        read_data_1 <= regs[read_reg_1];
        read_data_2 <= regs[read_reg_2];
    end

    always @(negedge clk, posedge rst) begin
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