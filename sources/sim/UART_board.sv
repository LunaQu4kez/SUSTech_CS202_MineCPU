module UART_board (
    input clk, rst_n, rx,
    output reg [7:0] led1_out, led2_out
);

    wire [31:0] data_out, addr_out;
    wire done;
    reg [7:0] reg1 = 0;
    reg [7:0] reg2 = 0;

    UART uart_inst (
        .clk,
        .rst(~rst_n),
        .rx,
        .data_out,
        .addr_out,
        .done
    );

    always_ff @(posedge clk) begin
        unique case (addr_out)
            32'h00000000: begin
                reg1 <= data_out[7:0];
                reg2 <= reg2;
            end
            32'h00000004: begin
                reg1 <= reg1;
                reg2 <= data_out[7:0];
            end
            default: begin
                reg1 <= reg1;
                reg2 <= reg2;
            end
        endcase
    end

    assign led1_out = reg1;
    assign led2_out = reg2;

endmodule