`include "Const.svh"

module Top (
    // clk -> cpuclk, memclk, vgaclk
    input                     cpuclk, memclk, vgaclk, rst_n,
    // uart related
    input  logic              rx,
    // interact with devices
    input  logic [`SWCH_WID ] switches1, switches2, switches3,
    input  logic              bt1, bt2, bt3, bt4, bt5,
    output logic [`LED_WID  ] led1_out, led2_out, led3_out,
    output logic [`LED_WID  ] seg_en, seg_out0, seg_out1,
    // vga interface
    output logic              hsync,              // line synchronization signal
    output logic              vsync,              // vertical synchronization signal
    output logic [`COLOR_WID] red,
    output logic [`COLOR_WID] green,
    output logic [`COLOR_WID] blue
);

    wire uart_done;
    wire [`DATA_WID] uart_data, uart_addr;
    wire [`VGA_ADDR] vga_addr;
    wire [`INFO_WID] char_out, color_out;
    wire [`DATA_WID] seg1_out, seg2_out;

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
        .led3_out,
        .seg1_out,
        .seg2_out
    );

    UART uart_inst(
        .clk(cpuclk),
        .rst(~rst_n),
        .rx(rx),
        .data_out(uart_data),
        .addr_out(uart_addr),
        .done(uart_done)
    );

    Seg7Tube seg7tube_inst(
        .clk(cpuclk),
        .rst_n,
        .seg1_in(seg1_out),
        .seg2_in(seg2_out),
        .seg_en,
        .seg_out0,
        .seg_out1
    );

    VGA vga_inst(
        .clk(vgaclk),
        .vga_addr,
        .char(char_out),
        .color(color_out),
        .hsync,
        .vsync,
        .red,
        .green,
        .blue
    );
    
endmodule
