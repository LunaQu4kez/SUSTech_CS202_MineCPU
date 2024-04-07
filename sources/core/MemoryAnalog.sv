`include "Const.svh"

module MemoryAnalog (
    input                       clka, clkb,
    input  logic [13:0     ]    addra, addrb,
    input  logic [`DATA_WID]    write_datab,
    input  logic [`DATA_WID]    web,            // port b write enable
    output logic [`DATA_WID]    dataa, datab
);
    reg [`DATA_WID] mem [16383:0] /*verilator public*/;
    reg [`DATA_WID] dataa_temp = 0;
    reg [`DATA_WID] datab_temp = 0;

    always_ff @(posedge clka) begin : inst_mem
        dataa <= dataa_temp;
        dataa_temp <= mem[addra];
    end

    always_ff @(posedge clkb) begin : data_mem
    datab <= datab_temp;
        unique if (~web) begin
            datab_temp <= mem[addrb];
        end
        else begin
            datab_temp <= write_datab;
            mem[addrb] <= write_datab;
        end
    end

endmodule