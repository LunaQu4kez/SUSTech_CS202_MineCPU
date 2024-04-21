`include "VGAConst.svh"

module VGA (  // 800×600 60Hz
    input  logic                clk,                // clk: 40MHz
    input  logic [`INFO_WID]    chars [`INFO_NUM],
    input  logic [`INFO_WID]    color [`INFO_NUM],
    output logic                hsync,              // line synchronization signal
    output logic                vsync,              // vertical synchronization signal
    output logic [`COLOR_WID]   red,
    output logic [`COLOR_WID]   green,
    output logic [`COLOR_WID]   blue
);
    


endmodule