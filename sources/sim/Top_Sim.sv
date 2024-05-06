module Top_Sim ();

    reg clk, rst, rx;
    reg [7:0] switches1, switches2;
    wire [7:0] led1_out, led2_out;

    Top top_inst (
        .clk,
        .rst,
        .rx,
        .switches1,
        .switches2,
        .led1_out,
        .led2_out
    );

    initial begin
        clk = 0;
        rst = 0;
        rx = 0;
        switches1 = 0;
        switches2 = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial fork
        #100 switches1 = 8'h4a;
        #240 switches1 = 8'h70;
    join

    initial fork
        #55 switches2 = 8'h8b;
        #140 switches2 = 8'hc1;
    join
    
endmodule