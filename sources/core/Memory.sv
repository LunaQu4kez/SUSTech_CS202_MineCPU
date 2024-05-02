`include "Const.svh"

module Memory (
    input                      clka, clkb,
    input  logic [`DATA_WID  ] addra, addrb,
    input  logic [`DATA_WID  ] write_datab,
    input  logic               web, // port b write enable
    input  logic [`DATA_WID  ] sepc,
    output logic [`DATA_WID  ] dataa, datab,
    // IO related
    input  logic [`SWCH_WID  ] switches1, switches2, switches3,
    input                      bt1, bt2, bt3, bt4, bt5,   // middle, up, down, left, right
    input  logic [`KBCODE_WID] kb_idx,                    // keyboard index: 0 1 2 3 4 5 6 7 8 9 A B C D * #
    output logic [`DATA_WID  ] seg1_out, seg2_out,
    output logic [`LED_WID   ] led1_out, led2_out,
    // vga related
    input  logic [`VGA_ADDR  ] vga_addr,
    output logic [`INFO_WID  ] char_out,
    output logic [`INFO_WID  ] color_out
);

    logic [`DATA_WID] wdatab, rdatab, datab_io;
    logic bool_io;
    assign bool_io = (addrb[31:16] == 16'hffff);  // 1: io, 0: mem
    assign datab = bool_io ? datab_io : rdatab;

    logic [`DATA_WID] rdataa, edataa = 0;
    logic bool_exc;  // exception or not
    assign bool_exc = (addra[31:16] == 16'h1c09);
    assign dataa = bool_exc ? edataa : rdataa;

    
    // IP RAM Simulation
    MemoryAnalog test_inst (
        .clka(~clka),
        .clkb(~clkb),
        .addra(addra[15:2]),
        .addrb(addrb[15:2]),
        .write_datab(bool_io ? 0 : wdatab),
        .web(web & ~bool_io),
        .dataa(rdataa),
        .datab(rdatab)
    );
    
    // Mem mem_inst (
    //     .clka(~clka),
    //     .clkb(~clkb),
    //     .addra(addra[15:2]),
    //     .addrb(addrb[15:2]),
    //     .dina(0),
    //     .dinb(bool_io ? 0 : wdatab),
    //     .douta(rdataa),
    //     .doutb(rdatab),
    //     .ena(1'b1),
    //     .enb(1'b1),
    //     .wea(1'b0),
    //     .web(web & ~bool_io)
    // );

    // Excp_ROM excp_rom_inst (
    //     .addra(addra[7:2]),
    //     .clka(~clka),
    //     .douta(edataa)
    // );

    // MMIO related
    logic [`LED_WID ] led1, led2;
    logic [`DATA_WID] seg1, seg2;
    logic [`INFO_WID] chars [`INFO_NUM];
    logic [`INFO_WID] color [`INFO_NUM]; 
    assign led1_out = led1;
    assign led2_out = led2;
    assign seg1_out = seg1;
    assign seg2_out = seg2;
    assign char_out = chars[vga_addr];
    assign color_out = color[vga_addr];

    always_comb begin
        unique case (addrb)
            32'hffff_ff00: begin     // switches1
                datab_io = {24'h000000, switches1};
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff04: begin     // switches2
                datab_io = {24'h000000, switches2};
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff08: begin     // switches3
                datab_io = {24'h000000, switches3};
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff0c: begin     // led1
                datab_io = 0;
                led1 = write_datab[7:0];
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff10: begin     // led2
                datab_io = 0;
                led1 = led1;
                led2 = write_datab[7:0];
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff14: begin     // button1 middle
                datab_io = bt1 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff18: begin     // button2 up
                datab_io = bt2 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff1c: begin     // button3 down
                datab_io = bt3 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff20: begin     // button4 left
                datab_io = bt4 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff24: begin     // button5 right
                datab_io = bt5 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff28: begin     // sepc: read
                datab_io = sepc;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff2c: begin     // seg1: write
                datab_io = datab_io;
                led1 = led1;
                led2 = led2;
                seg1 = write_datab;
                seg2 = seg2;
            end
            32'hffff_ff30: begin     // seg2: write
                datab_io = datab_io;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = write_datab;
            end
            32'hffff_ff34: begin     // keyboard enable
                datab_io = kb_idx[4] ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            32'hffff_ff38: begin     // 4*4 keyboard
                datab_io = {28'h0000000, kb_idx[3:0]};
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
            default: begin
                datab_io = 0;
                led1 = led1;
                led2 = led2;
                seg1 = seg1;
                seg2 = seg2;
            end
        endcase
    end

    // vga write
    always_comb begin
        unique case (addrb[31:12])
            20'hffffe: begin
                chars[addrb[11:0]] = write_datab[7:0];
                color = color;
            end
            20'hffffd: begin
                chars = chars;
                color[addrb[11:0]] = write_datab[7:0];
            end
            default: begin
                chars = chars;
                color = color;
            end
        endcase
    end

endmodule
