`include "Const.svh"

module Memory (
    input                       clka, clkb,
    input  logic [`DATA_WID]    addra, addrb,
    input  logic [`DATA_WID]    write_datab,
    input  logic [`DATA_WID]    web,            // port b write enable
    output logic [`DATA_WID]    dataa, datab
    // uart related
    // ......
    // IO related
    // ......
);




endmodule