`include "Const.svh"

module Memory (
    input                       clka, clkb, rst,
    input  logic [`LDST_WID]    LDST,
    input  logic [`DATA_WID]    addra, addrb,
    input  logic [`DATA_WID]    write_datab,
    input  logic [`DATA_WID]    web,            // port b write enable
    output logic [`DATA_WID]    dataa, datab
    // uart related
    // ......
    // IO related
    // ......
);

    logic [1:0] cnt = 2'b00;
    logic we;
    assign we = web & (cnt == 3);

    always_ff @(posedge clkb) begin : counter
        if (cnt == 3) cnt <= 0;
        else cnt <= cnt + 1;
    end

    logic [`DATA_WID] wdatab, rdatab;

    // IP RAM
    /*
    TestMemory test_inst (
        .clka(~clka),
        .clkb(~clkb),
        .addra(addra[15:2]),
        .addrb(addrb[15:2]),
        .write_datab(wdatab),
        .web(we),
        .dataa,
        .datab(rdatab)
    );
    */

    Mem mem_inst (
        .clka(~clka),
        .clkb(~clkb),
        .addra(addra[15:2]),
        .addrb(addrb[15:2]),
        .dina(0),
        .dinb(wdatab),
        .douta(dataa),
        .doutb(rdatab),
        .ena(1'b1),
        .enb(1'b1),
        .wea(1'b0),
        .web(we)
    );

    always_comb begin
        unique case (LDST)
            `LW_OP: begin
                datab = rdatab;
            end
            `LH_OP: begin
                if (addrb[1]) begin
                    datab = {rdatab[31] ? 16'hffff : 16'h0000, rdatab[31:16]};
                end
                else begin
                    datab = {rdatab[15] ? 16'hffff : 16'h0000, rdatab[15:0]};
                end
            end
            `LHU_OP: begin
                datab = {16'h0000, addrb[1] ? rdatab[31:16] : rdatab[15:0]};
            end
            `LBU_OP: begin
                datab = {24'h000000, addrb[1] ? (addrb[0] ? rdatab[31:24] : rdatab[23:16]) : (addrb[0] ? rdatab[15:8] : rdatab[7:0])};
            end
            `LB_OP: begin
                unique case (addrb[1:0])
                    2'b00: datab = {rdatab[7] ? 24'hffffff : 24'h000000, rdatab[7:0]};
                    2'b01: datab = {rdatab[15] ? 24'hffffff : 24'h000000, rdatab[15:8]};
                    2'b10: datab = {rdatab[23] ? 24'hffffff : 24'h000000, rdatab[23:16]};
                    2'b11: datab = {rdatab[31] ? 24'hffffff : 24'h000000, rdatab[31:24]};
                endcase
            end
            `SW_OP: begin
                wdatab = write_datab;
            end
            `SH_OP: begin
                wdatab = addrb[1] ? {write_datab[15:0], rdatab[15:0]} : {rdatab[31:16], write_datab[15:0]};
            end
            `SB_OP: begin
                unique case (addrb[1:0])
                    2'b00: wdatab = {rdatab[31:8], write_datab[7:0]};
                    2'b01: wdatab = {rdatab[31:16], write_datab[7:0], rdatab[7:0]}; 
                    2'b10: wdatab = {rdatab[31:24], write_datab[7:0], rdatab[15:0]}; 
                    2'b11: wdatab = {write_datab[7:0], rdatab[23:0]}; 
                endcase
            end
        endcase
    end


// MMIO Regs


endmodule