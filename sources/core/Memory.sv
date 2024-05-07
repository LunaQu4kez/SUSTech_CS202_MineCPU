`include "Const.svh"

module Memory (
    input                      clka, clkb,
    input  logic [`DATA_WID  ] addra, addrb,
    input  logic [`DATA_WID  ] write_datab,
    input  logic               web, // port b write enable
    output logic [`DATA_WID  ] dataa, datab,
    // IO related
    input  logic [`SWCH_WID  ] switches1, switches2, switches3,
    input                      bt1, bt2, bt3, bt4, bt5,   // middle, up, down, left, right
    input  logic [`KBCODE_WID] kb_idx,                    // keyboard index: 0 1 2 3 4 5 6 7 8 9 A B C D * #
    output logic [`DATA_WID  ] seg1_out,
    output logic [`LED_WID   ] led1_out, led2_out,
    // vga related
    input  logic [`VGA_ADDR  ] vga_addr,
    output logic [`INFO_WID  ] char_out,
    output logic [`INFO_WID  ] color_out
);

    logic [`DATA_WID] rdataa, rdatab, datab_io, edataa;
    logic bool_io;   // mmio or mem
    logic bool_exc;  // exception or not
    assign bool_io = (addrb[31:16] == 16'hffff);  // 1: io, 0: mem
    assign datab = bool_io ? datab_io : rdatab;
    assign bool_exc = (addra[31:16] == 16'h1c09); // 1: exc, 0: mem
    assign dataa = bool_exc ? edataa : rdataa;

    // IP RAM Simulation
    // MemoryAnalog test_inst (
    //     .clka(~clka),
    //     .clkb(~clkb),
    //     .addra(addra[15:2]),
    //     .addrb(addrb[15:2]),
    //     .write_datab(bool_io ? 0 : write_datab),
    //     .web(web & ~bool_io),
    //     .dataa(rdataa),
    //     .datab(rdatab)
    // );
    
    Mem mem_inst (
        .clka(~clka),
        .clkb(~clkb),
        .addra(addra[15:2]),
        .addrb(addrb[15:2]),
        .dina(0),
        .dinb(bool_io ? 0 : write_datab),
        .douta(rdataa),
        .doutb(rdatab),
        .ena(1'b1),
        .enb(1'b1),
        .wea(1'b0),
        .web(web & ~bool_io)
    );

    always_comb begin : exception_instruction
        unique case (addra)
            32'h1c090000: edataa = 32'hff810113;
            32'h1c090004: edataa = 32'h00512223;
            32'h1c090008: edataa = 32'h00612023;
            32'h1c09000c: edataa = 32'h00a00293;
            32'h1c090010: edataa = 32'h02588863;
            32'h1c090014: edataa = 32'h00500293;
            32'h1c090018: edataa = 32'h02588663;
            32'h1c09001c: edataa = 32'h00600293;
            32'h1c090020: edataa = 32'h02588663;
            32'h1c090024: edataa = 32'h00100293;
            32'h1c090028: edataa = 32'h02588663;
            32'h1c09002c: edataa = 32'h00200293;
            32'h1c090030: edataa = 32'h02588663;
            32'h1c090034: edataa = 32'h00300293;
            32'h1c090038: edataa = 32'h02588663;
            32'h1c09003c: edataa = 32'h0300006f;
            32'h1c090040: edataa = 32'h00000013;
            32'h1c090044: edataa = 32'h0000006f;
            32'h1c090048: edataa = 32'h0001a503;
            32'h1c09004c: edataa = 32'h0240006f;
            32'h1c090050: edataa = 32'h0041a503;
            32'h1c090054: edataa = 32'h01c0006f;
            32'h1c090058: edataa = 32'h00a1a623;
            32'h1c09005c: edataa = 32'h0140006f;
            32'h1c090060: edataa = 32'h00a1a823;
            32'h1c090064: edataa = 32'h00c0006f;
            32'h1c090068: edataa = 32'h02a1a623;
            32'h1c09006c: edataa = 32'h0040006f;
            32'h1c090070: edataa = 32'h00012303;
            32'h1c090074: edataa = 32'h00412283;
            32'h1c090078: edataa = 32'h00810113;
            32'h1c09007c: edataa = 32'h10200073;
            default: edataa = 32'h00000000;
        endcase
    end

    // MMIO related
    logic [`LED_WID ] led1 = 0, led2 = 0;
    logic [`DATA_WID] seg1 = 0;
    logic [`INFO_WID] chars [`INFO_NUM];
    logic [`INFO_WID] color [`INFO_NUM]; 
    assign led1_out = led1;
    assign led2_out = led2;
    assign seg1_out = seg1;
    assign char_out = chars[vga_addr];
    assign color_out = color[vga_addr];

    always_comb begin
        unique case (addrb)
            32'hffff_ff00: begin     // switches1
                datab_io = {24'h000000, switches1};
            end
            32'hffff_ff04: begin     // switches2
                datab_io = {24'h000000, switches2};
            end
            32'hffff_ff08: begin     // switches3
                datab_io = {24'h000000, switches3};
            end
            32'hffff_ff0c: begin     // led1
                datab_io = 0;
            end
            32'hffff_ff10: begin     // led2
                datab_io = 0;
            end
            32'hffff_ff14: begin     // button1 middle
                datab_io = bt1 ? 32'h00000001 : 32'h00000000;
            end
            32'hffff_ff18: begin     // button2 up
                datab_io = bt2 ? 32'h00000001 : 32'h00000000;
            end
            32'hffff_ff1c: begin     // button3 down
                datab_io = bt3 ? 32'h00000001 : 32'h00000000;
            end
            32'hffff_ff20: begin     // button4 left
                datab_io = bt4 ? 32'h00000001 : 32'h00000000;
            end
            32'hffff_ff24: begin     // button5 right
                datab_io = bt5 ? 32'h00000001 : 32'h00000000;
            end
            32'hffff_ff28: begin     // reserved
                datab_io = 0;
            end
            32'hffff_ff2c: begin     // seg1: write
                datab_io = 0;
            end
            32'hffff_ff34: begin     // keyboard enable
                datab_io = kb_idx[4] ? 32'h00000001 : 32'h00000000;
            end
            32'hffff_ff38: begin     // 4*4 keyboard
                datab_io = {28'h0000000, kb_idx[3:0]};
            end
            default: begin
                datab_io = 0;
            end
        endcase
    end

    always_ff @(posedge clkb) begin
        unique case (addrb)
            32'hffff_ff0c: begin     // led1
                led1 <= write_datab[7:0];
                led2 <= led2;
                seg1 <= seg1;
            end
            32'hffff_ff10: begin     // led2
                led1 <= led1;
                led2 <= write_datab[7:0];
                seg1 <= seg1;
            end
            32'hffff_ff2c: begin     // seg1: write
                led1 <= led1;
                led2 <= led2;
                seg1 <= write_datab;
            end
            default: begin
                led1 <= led1;
                led2 <= led2;
                seg1 <= seg1;
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
