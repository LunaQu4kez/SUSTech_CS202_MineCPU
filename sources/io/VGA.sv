`include "Const.svh"

module VGA (  // 800×600 60Hz
    input  logic              clk,      // clk: 40MHz
    // get char and color from memory
    output logic [`VGA_ADDR]  vga_addr,
    input  logic [`INFO_WID ] ch,
    input  logic [`INFO_WID ] color,    // 0: white   1: yellow      2: red        3: pink
                                        // 4: orange  5: light blue  6: dark blue
    // output to VGA
    output logic              hsync,    // line synchronization signal
    output logic              vsync,    // vertical synchronization signal
    output logic [`COLOR_WID] red,
    output logic [`COLOR_WID] green,
    output logic [`COLOR_WID] blue
);
    


endmodule
