`include "Const.svh"

module Top (
    // clk -> cpuclk, memclk, vgaclk
    input                     clk, rst_n,
    // uart related
    input  logic              rx,
    // interact with devices
    input  logic [`SWCH_WID ] switches1, switches2, switches3,
    input  logic              bt1, bt2, bt3, bt4, bt5,
    input  logic [`KBPIN_WID] kp,
    output logic [`LED_WID  ] led1_out, led2_out, led3_out,
    output logic [`LED_WID  ] seg_en, seg_out,
    // vga interface
    output logic              hsync,              // line synchronization signal
    output logic              vsync,              // vertical synchronization signal
    output logic [`COLOR_WID] red,
    output logic [`COLOR_WID] green,
    output logic [`COLOR_WID] blue
);

    wire cpuclk, memclk, vgaclk;
    wire uart_done;
    wire [`DATA_WID] uart_data, uart_addr;
    wire [`VGA_ADDR] vga_addr;
    wire [`INFO_WID] char_out, color_out;
    wire [`DATA_WID] seg1_out, seg2_out;
    wire [4:0] kb_idx;

    assign cpuclk = clk;  // 100MHz
    assign memclk = clk;  // 100MHz

    VGAClkGen vga_clk_gen_inst (  // 40MHz
        .clk_in1(clk),
        .clk_out1(vgaclk)
    );

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
        .kb_idx,
        .led1_out,
        .led2_out,
        .led3_out,
        .seg1_out,
        .seg2_out,
        .vga_addr,
        .char_out,
        .color_out
    );

    UART uart_inst(
        .clk,
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
        .seg_out
    );

    VGA vga_inst(
        .clk(vgaclk),
        .vga_addr,
        .ch(char_out),
        .color(color_out),
        .hsync,
        .vsync,
        .red,
        .green,
        .blue
    );

    Keyboard keyboard_inst (
        .kp,
        .kb_idx
    );
    
endmodule
