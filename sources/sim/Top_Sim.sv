module Top_Sim ();

    reg clk, rst, rx;
    reg [7:0] switches1;
    wire [7:0] led1_out;

    Top top_inst (
        .clk,
        .rst,
        .rx,
        .switches1,
        .led1_out
    );

    initial begin
        clk = 0;
        rst = 0;
        rx = 0;
        switches1 = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial fork
        #100 switches1 = 8'h4a;
        #240 switches1 = 8'h00;
    join
    
endmodule