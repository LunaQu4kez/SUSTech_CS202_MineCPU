`include "Const.svh"

module Memory (
    input                       clka, clkb, // rst,
    input  logic [`LDST_WID]    LDST,
    input  logic [`DATA_WID]    addra, addrb,
    input  logic [`DATA_WID]    write_datab,
    input  logic                web, // port b write enable
    output logic [`DATA_WID]    dataa, datab,
    // uart related
    // ......
    // IO related
    input  logic [7:0]          switches,
    output logic [31:0]         led_out
);

    reg [1:0] cnt = 2'b00;
    logic we;
    assign we = web & (cnt == 3);

    always_ff @(posedge clkb) begin : counter
        if (cnt == 3) cnt <= 0;
        else cnt <= cnt + 1;
    end

    logic [`DATA_WID] wdatab, rdatab;
    logic [`DATA_WID] datab_mem, datab_io;
    logic bool_io;
    assign bool_io = (addrb[31:16] == 16'hffff);  // 1: io, 0: mem
    assign datab = bool_io ? datab_io : datab_mem;

    
    // IP RAM
    /*
    MemoryAnalog test_inst (
        .clka(~clka),
        .clkb(~clkb),
        .addra(addra[15:2]),
        .addrb(addrb[15:2]),
        .write_datab(bool_io ? 0 : wdatab),
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
        .dinb(bool_io ? 0 : wdatab),
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
                datab_mem = rdatab;
                wdatab = 0;
            end
            `LH_OP: begin
                if (addrb[1]) begin
                    datab_mem = {rdatab[31] ? 16'hffff : 16'h0000, rdatab[31:16]};
                end
                else begin
                    datab_mem = {rdatab[15] ? 16'hffff : 16'h0000, rdatab[15:0]};
                end
                wdatab = 0;
            end
            `LHU_OP: begin
                datab_mem = {16'h0000, addrb[1] ? rdatab[31:16] : rdatab[15:0]};
                wdatab = 0;
            end
            `LBU_OP: begin
                datab_mem = {24'h000000, addrb[1] ? (addrb[0] ? rdatab[31:24] : rdatab[23:16]) : (addrb[0] ? rdatab[15:8] : rdatab[7:0])};
                wdatab = 0;
            end
            `LB_OP: begin
                unique case (addrb[1:0])
                    2'b00: datab_mem = {rdatab[7] ? 24'hffffff : 24'h000000, rdatab[7:0]};
                    2'b01: datab_mem = {rdatab[15] ? 24'hffffff : 24'h000000, rdatab[15:8]};
                    2'b10: datab_mem = {rdatab[23] ? 24'hffffff : 24'h000000, rdatab[23:16]};
                    2'b11: datab_mem = {rdatab[31] ? 24'hffffff : 24'h000000, rdatab[31:24]};
                endcase
                wdatab = 0;
            end
            `SW_OP: begin
                wdatab = write_datab;
                datab_mem = rdatab;
            end
            `SH_OP: begin
                wdatab = addrb[1] ? {write_datab[15:0], rdatab[15:0]} : {rdatab[31:16], write_datab[15:0]};
                datab_mem = rdatab;
            end
            `SB_OP: begin
                unique case (addrb[1:0])
                    2'b00: wdatab = {rdatab[31:8], write_datab[7:0]};
                    2'b01: wdatab = {rdatab[31:16], write_datab[7:0], rdatab[7:0]}; 
                    2'b10: wdatab = {rdatab[31:24], write_datab[7:0], rdatab[15:0]}; 
                    2'b11: wdatab = {write_datab[7:0], rdatab[23:0]}; 
                endcase
                datab_mem = rdatab;
            end
        endcase
    end


    // MMIO Regs
    // output
    logic [31:0] led = 0;
    assign led_out = led;

    always_comb begin
        unique case (addrb)
            32'hffff_ff00: begin     // switches
                datab_io = {24'h000000, switches};
                led = led;
            end
            32'hffff_ff04: begin     // led
                datab_io = 0;
                led = write_datab;
            end
            default: begin
                datab_io = 0;
                led = led;
            end
        endcase
    end


endmodule
