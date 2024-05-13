module VGA (  // 800×600 60Hz
    input  logic              clk,      // clk: 40MHz
    // get char and color from memory
    output logic [`VGA_ADDR]  vga_addr,
    input  logic [`INFO_WID ] ch,
    input  logic [`INFO_WID ] color,    // 0: black   1: yellow      2: red        3: pink
                                        // 4: orange  5: light blue  6: dark blue  8: white
    // output to VGA
    output logic              hsync,    // line synchronization signal
    output logic              vsync,    // vertical synchronization signal
    output logic [`COLOR_WID] red,
    output logic [`COLOR_WID] green,
    output logic [`COLOR_WID] blue
);

    reg [10:0] hc;
    always @(posedge clk) begin
        if (hc == `H_LINE_PERIOD - 1) hc <= 0;
        else hc <= hc + 1;
    end
    reg [10:0] vc;
    always @(posedge clk) begin
        if (vc == `V_FRAME_PERIOD - 1) vc <= 0;
        else if (hc == `H_LINE_PERIOD - 1) vc <= vc + 1;
        else vc <= vc;
    end

    wire [10:0] hc0, vc0;
    assign hsync = (hc < `H_SYNC_PULSE) ? 0 : 1;
    assign vsync = (vc < `V_SYNC_PULSE) ? 0 : 1;
    assign hc0 = hc - `H_SYNC_PULSE - `H_BACK_PORCH;
    assign vc0 = vc - `V_SYNC_PULSE - `V_BACK_PORCH;

    wire active;  
    assign active = (hc >= `H_SYNC_PULSE + `H_BACK_PORCH) &&
                    (hc < `H_SYNC_PULSE + `H_BACK_PORCH + `H_ACTIVE_TIME) &&
                    (vc >= `V_SYNC_PULSE + `V_BACK_PORCH) &&
                    (vc < `V_SYNC_PULSE + `V_BACK_PORCH + `V_ACTIVE_TIME) ? 1 : 0;

    wire [7:0] x, y, char_addr;
    reg [127:0] have_ch = 0;
    reg [127:0] temp_ch;
    wire have_ch0;
    wire flag = hc0 > 15 && hc0 < 784 && vc0 > 43 && vc0 < 556;

    assign char_addr = (hc0-16)&8 + ((vc0-44)&16) << 3;
    assign x = (hc0-16) >> 3;
    assign y = (vc0-44) >> 4;
    assign vga_addr = 96*y+ x;
    assign have_ch0 = have_ch[char_addr];

    always @(posedge active) begin
        have_ch <= flag ? temp_ch : 128'h00000000000000000000000000000000;
    end

    always_comb begin
        case (color)
            8'b00000000: {red,green,blue} = have_ch0 ? {`BLACK_R,`BLACK_G,`BLACK_B} : 12'h000;
            8'b00000001: {red,green,blue} = have_ch0 ? {`YELLOW_R,`YELLOW_G,`YELLOW_B} : 12'h000;
            8'b00000010: {red,green,blue} = have_ch0 ? {`RED_R,`RED_G,`RED_B} : 12'h000;
            8'b00000011: {red,green,blue} = have_ch0 ? {`PINK_R,`PINK_G,`PINK_B} : 12'h000;
            8'b00000100: {red,green,blue} = have_ch0 ? {`ORANGE_R,`ORANGE_G,`ORANGE_B} : 12'h000;
            8'b00000101: {red,green,blue} = have_ch0 ? {`LBLUE_R,`LBLUE_G,`LBLUE_B} : 12'h000;
            8'b00000110: {red,green,blue} = have_ch0 ? {`DBLUE_R,`DBLUE_G,`DBLUE_B} : 12'h000;
            8'b00000111: {red,green,blue} = have_ch0 ? {`WHITH_R,`WHITH_G,`WHITH_B} : 12'h000;
                default: {red,green,blue} = 12'b000000000000;
        endcase
    end

    always_comb begin
        case (ch)
                8'd0: temp_ch = `CHAR_0;
                8'd1: temp_ch = `CHAR_1;
                8'd2: temp_ch = `CHAR_2;
                8'd3: temp_ch = `CHAR_3;
                8'd4: temp_ch = `CHAR_4;
                8'd5: temp_ch = `CHAR_5;
                8'd6: temp_ch = `CHAR_6;
                8'd7: temp_ch = `CHAR_7;
                8'd8: temp_ch = `CHAR_8;
                8'd9: temp_ch = `CHAR_9;
                8'd10: temp_ch = `CHAR_10;
                8'd11: temp_ch = `CHAR_11;
                8'd12: temp_ch = `CHAR_12;
                8'd32: temp_ch = `CHAR_32;
                8'd33: temp_ch = `CHAR_33;
                8'd34: temp_ch = `CHAR_34;
                8'd35: temp_ch = `CHAR_35;
                8'd36: temp_ch = `CHAR_36;
                8'd37: temp_ch = `CHAR_37;
                8'd38: temp_ch = `CHAR_38;
                8'd39: temp_ch = `CHAR_39;
                8'd40: temp_ch = `CHAR_40;
                8'd41: temp_ch = `CHAR_41;
                8'd42: temp_ch = `CHAR_42;
                8'd43: temp_ch = `CHAR_43;
                8'd44: temp_ch = `CHAR_44;
                8'd45: temp_ch = `CHAR_45;
                8'd46: temp_ch = `CHAR_46;
                8'd47: temp_ch = `CHAR_47;
                8'd48: temp_ch = `CHAR_48;
                8'd49: temp_ch = `CHAR_49;
                8'd50: temp_ch = `CHAR_50;
                8'd51: temp_ch = `CHAR_51;
                8'd52: temp_ch = `CHAR_52;
                8'd53: temp_ch = `CHAR_53;
                8'd54: temp_ch = `CHAR_54;
                8'd55: temp_ch = `CHAR_55;
                8'd56: temp_ch = `CHAR_56;
                8'd57: temp_ch = `CHAR_57;
                8'd58: temp_ch = `CHAR_58;
                8'd59: temp_ch = `CHAR_59;
                8'd60: temp_ch = `CHAR_60;
                8'd61: temp_ch = `CHAR_61;
                8'd62: temp_ch = `CHAR_62;
                8'd63: temp_ch = `CHAR_63;
                8'd64: temp_ch = `CHAR_64;
                8'd65: temp_ch = `CHAR_65;
                8'd66: temp_ch = `CHAR_66;
                8'd67: temp_ch = `CHAR_67;
                8'd68: temp_ch = `CHAR_68;
                8'd69: temp_ch = `CHAR_69;
                8'd70: temp_ch = `CHAR_70;
                8'd71: temp_ch = `CHAR_71;
                8'd72: temp_ch = `CHAR_72;
                8'd73: temp_ch = `CHAR_73;
                8'd74: temp_ch = `CHAR_74;
                8'd75: temp_ch = `CHAR_75;
                8'd76: temp_ch = `CHAR_76;
                8'd77: temp_ch = `CHAR_77;
                8'd78: temp_ch = `CHAR_78;
                8'd79: temp_ch = `CHAR_79;
                8'd80: temp_ch = `CHAR_80;
                8'd81: temp_ch = `CHAR_81;
                8'd82: temp_ch = `CHAR_82;
                8'd83: temp_ch = `CHAR_83;
                8'd84: temp_ch = `CHAR_84;
                8'd85: temp_ch = `CHAR_85;
                8'd86: temp_ch = `CHAR_86;
                8'd87: temp_ch = `CHAR_87;
                8'd88: temp_ch = `CHAR_88;
                8'd89: temp_ch = `CHAR_89;
                8'd90: temp_ch = `CHAR_90;
                8'd91: temp_ch = `CHAR_91;
                8'd92: temp_ch = `CHAR_92;
                8'd93: temp_ch = `CHAR_93;
                8'd94: temp_ch = `CHAR_94;
                8'd95: temp_ch = `CHAR_95;
                8'd96: temp_ch = `CHAR_96;
                8'd97: temp_ch = `CHAR_97;
                8'd98: temp_ch = `CHAR_98;
                8'd99: temp_ch = `CHAR_99;
                8'd100: temp_ch = `CHAR_100;
                8'd101: temp_ch = `CHAR_101;
                8'd102: temp_ch = `CHAR_102;
                8'd103: temp_ch = `CHAR_103;
                8'd104: temp_ch = `CHAR_104;
                8'd105: temp_ch = `CHAR_105;
                8'd106: temp_ch = `CHAR_106;
                8'd107: temp_ch = `CHAR_107;
                8'd108: temp_ch = `CHAR_108;
                8'd109: temp_ch = `CHAR_109;
                8'd110: temp_ch = `CHAR_110;
                8'd111: temp_ch = `CHAR_111;
                8'd112: temp_ch = `CHAR_112;
                8'd113: temp_ch = `CHAR_113;
                8'd114: temp_ch = `CHAR_114;
                8'd115: temp_ch = `CHAR_115;
                8'd116: temp_ch = `CHAR_116;
                8'd117: temp_ch = `CHAR_117;
                8'd118: temp_ch = `CHAR_118;
                8'd119: temp_ch = `CHAR_119;
                8'd120: temp_ch = `CHAR_120;
                8'd121: temp_ch = `CHAR_121;
                8'd122: temp_ch = `CHAR_122;
                8'd123: temp_ch = `CHAR_123;
                8'd124: temp_ch = `CHAR_124;
                8'd125: temp_ch = `CHAR_125;
                8'd126: temp_ch = `CHAR_126;
               default: temp_ch = 0;
        endcase
    end

endmodule
