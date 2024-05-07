module UART_board (
    input clk, rst, rx,
    input [7:0] switches1, switches2,
    output reg [7:0] led1_out, led2_out, led3_out,
    output [7:0] seg_en, seg_out
);

    wire [31:0] data_out, addr_out, data_in;
    wire done;
    reg [31:0] mem [0:16383];
    wire [13:0] temp;
    assign temp = {switches1, switches2[7:2]};
    assign data_in = mem[temp];

    UART uart_inst (
        .clk,
        .rst,
        .rx,
        .data_out,
        .addr_out,
        .done
    );

    Seg7Tube seg_tube_inst (
        .clk,
        .rst_n(~rst),
        .data_in,
        .seg_en,
        .seg_out
    );

    always_ff @(posedge clk) begin
        mem[addr_out[15:2]] <= data_out;
    end

    assign led1_out = addr_out[15:8];
    assign led2_out[7:2] = addr_out[7:2];
    assign led2_out[1:0] = 2'b00;
    assign led3_out[7] = done;
    assign led3_out[6] = rst;
    assign led3_out[5] = rx;

endmodule