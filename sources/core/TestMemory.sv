`include "Const.svh"

module TestMemory (
    input                       clka, clkb,
    input  logic [`DATA_WID]    addra, addrb,
    input  logic [`DATA_WID]    write_datab,
    input  logic [`DATA_WID]    web,            // port b write enable
    output logic [`DATA_WID]    dataa, datab
);
    reg [`DATA_WID] mem [31:0] /*verilator public*/;
endmodule