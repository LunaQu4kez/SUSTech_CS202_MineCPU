module Top (
    // clk -> cpuclk, memclk
    input              cpuclk, memclk, rst_n,
    // uart related
    input  logic       rx,
    // interact with devices
    input  logic [7:0] switches1, switches2, switches3,
    input  logic       bt1, bt2, bt3, bt4, bt5,
    output logic [7:0] led1_out, led2_out, led3_out
);

    wire uart_done;
    wire [31:0] uart_data, uart_addr;

    CPU cpu_inst(
        .cpuclk,
        .memclk,
        .rst_n,
        .uart_data,
        .uart_addr,
        .uart_done,
        .switches1,
        .switches2,
        .switches3,
        .bt1,
        .bt2,
        .bt3,
        .bt4,
        .bt5,
        .led1_out,
        .led2_out,
        .led3_out
    );

    UART uart_inst(
        .clk(cpuclk),
        .rst(~rst_n),
        .rx(rx),
        .data_out(uart_data),
        .addr_out(uart_addr),
        .done(uart_done)
    );
    
endmodule
