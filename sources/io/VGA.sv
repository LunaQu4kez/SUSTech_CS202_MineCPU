`include "VGAConst.svh"

module VGA (  // 800×600 60Hz
    input  logic              clk,      // clk: 40MHz
    // get char and color from memory
    output logic [`VGA_ADDR]  vga_addr,
    input  logic [`INFO_WID ] char,
    input  logic [`INFO_WID ] color,    // first 4 bit means the up 8*8's color, last 4 bit means the down 8*8's color
                                        // 0000: white   0001: yellow      0010: red        0011: pink
                                        // 0100: orange  0101: light blue  0110: dark blue
    // output to VGA
    output logic              hsync,    // line synchronization signal
    output logic              vsync,    // vertical synchronization signal
    output logic [`COLOR_WID] red,
    output logic [`COLOR_WID] green,
    output logic [`COLOR_WID] blue
);
    


endmodule
