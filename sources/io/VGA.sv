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
    assign vga_addr = 0;
    assign hsync = 0;
    assign vsync = 0;
    assign red = 0;
    assign green = 0;
    assign blue = 0;

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

    wire [7:0] x,y,char_num,char_addr;
    reg [127:0] have_ch = 0;
    wire have_ch0;

    assign char_addr = hc0%8 + (vc0%16)*8;
    assign x = hc0 >> 3;
    assign y = vc0 >> 4;
    assign vga_addr = 96*y+ x;
    assign have_ch0 = have_ch[char_addr];

    always @(posedge active) begin
        if (hc0 > 15 && hc0 < 784 && vc0 > 43 && vc0 < 556) begin
            case (ch)
                8'd0:have_ch <= `CHAR_0;
                8'd1:have_ch <= `CHAR_1;
                8'd2:have_ch <= `CHAR_2;
                8'd3:have_ch <= `CHAR_3;
                8'd4:have_ch <= `CHAR_4;
                8'd5:have_ch <= `CHAR_5;
                8'd6:have_ch <= `CHAR_6;
                8'd7:have_ch <= `CHAR_7;
                8'd8:have_ch <= `CHAR_8;
                8'd9:have_ch <= `CHAR_9;
                8'd10:have_ch <= `CHAR_10;
                8'd11:have_ch <= `CHAR_11;
                8'd32:have_ch <= `CHAR_32;
                8'd33:have_ch <= `CHAR_33;
                8'd34:have_ch <= `CHAR_34;
                8'd35:have_ch <= `CHAR_35;
                8'd36:have_ch <= `CHAR_36;
                8'd37:have_ch <= `CHAR_37;
                8'd38:have_ch <= `CHAR_38;
                8'd39:have_ch <= `CHAR_39;
                8'd40:have_ch <= `CHAR_40;
                8'd41:have_ch <= `CHAR_41;
                8'd42:have_ch <= `CHAR_42;
                8'd43:have_ch <= `CHAR_43;
                8'd44:have_ch <= `CHAR_44;
                8'd45:have_ch <= `CHAR_45;
                8'd46:have_ch <= `CHAR_46;
                8'd47:have_ch <= `CHAR_47;
                8'd48:have_ch <= `CHAR_48;
                8'd49:have_ch <= `CHAR_49;
                8'd50:have_ch <= `CHAR_50;
                8'd51:have_ch <= `CHAR_51;
                8'd52:have_ch <= `CHAR_52;
                8'd53:have_ch <= `CHAR_53;
                8'd54:have_ch <= `CHAR_54;
                8'd55:have_ch <= `CHAR_55;
                8'd56:have_ch <= `CHAR_56;
                8'd57:have_ch <= `CHAR_57;
                8'd58:have_ch <= `CHAR_58;
                8'd59:have_ch <= `CHAR_59;
                8'd60:have_ch <= `CHAR_60;
                8'd61:have_ch <= `CHAR_61;
                8'd62:have_ch <= `CHAR_62;
                8'd63:have_ch <= `CHAR_63;
                8'd64:have_ch <= `CHAR_64;
                8'd65:have_ch <= `CHAR_65;
                8'd66:have_ch <= `CHAR_66;
                8'd67:have_ch <= `CHAR_67;
                8'd68:have_ch <= `CHAR_68;
                8'd69:have_ch <= `CHAR_69;
                8'd70:have_ch <= `CHAR_70;
                8'd71:have_ch <= `CHAR_71;
                8'd72:have_ch <= `CHAR_72;
                8'd73:have_ch <= `CHAR_73;
                8'd74:have_ch <= `CHAR_74;
                8'd75:have_ch <= `CHAR_75;
                8'd76:have_ch <= `CHAR_76;
                8'd77:have_ch <= `CHAR_77;
                8'd78:have_ch <= `CHAR_78;
                8'd79:have_ch <= `CHAR_79;
                8'd80:have_ch <= `CHAR_80;
                8'd81:have_ch <= `CHAR_81;
                8'd82:have_ch <= `CHAR_82;
                8'd83:have_ch <= `CHAR_83;
                8'd84:have_ch <= `CHAR_84;
                8'd85:have_ch <= `CHAR_85;
                8'd86:have_ch <= `CHAR_86;
                8'd87:have_ch <= `CHAR_87;
                8'd88:have_ch <= `CHAR_88;
                8'd89:have_ch <= `CHAR_89;
                8'd90:have_ch <= `CHAR_90;
                8'd91:have_ch <= `CHAR_91;
                8'd92:have_ch <= `CHAR_92;
                8'd93:have_ch <= `CHAR_93;
                8'd94:have_ch <= `CHAR_94;
                8'd95:have_ch <= `CHAR_95;
                8'd96:have_ch <= `CHAR_96;
                8'd97:have_ch <= `CHAR_97;
                8'd98:have_ch <= `CHAR_98;
                8'd99:have_ch <= `CHAR_99;
                8'd100:have_ch <= `CHAR_100;
                8'd101:have_ch <= `CHAR_101;
                8'd102:have_ch <= `CHAR_102;
                8'd103:have_ch <= `CHAR_103;
                8'd104:have_ch <= `CHAR_104;
                8'd105:have_ch <= `CHAR_105;
                8'd106:have_ch <= `CHAR_106;
                8'd107:have_ch <= `CHAR_107;
                8'd108:have_ch <= `CHAR_108;
                8'd109:have_ch <= `CHAR_109;
                8'd110:have_ch <= `CHAR_110;
                8'd111:have_ch <= `CHAR_111;
                8'd112:have_ch <= `CHAR_112;
                8'd113:have_ch <= `CHAR_113;
                8'd114:have_ch <= `CHAR_114;
                8'd115:have_ch <= `CHAR_115;
                8'd116:have_ch <= `CHAR_116;
                8'd117:have_ch <= `CHAR_117;
                8'd118:have_ch <= `CHAR_118;
                8'd119:have_ch <= `CHAR_119;
                8'd120:have_ch <= `CHAR_120;
                8'd121:have_ch <= `CHAR_121;
                8'd122:have_ch <= `CHAR_122;
                8'd123:have_ch <= `CHAR_123;
                8'd124:have_ch <= `CHAR_124;
                8'd125:have_ch <= `CHAR_125;
                8'd126:have_ch <= `CHAR_126;
                default: have_ch <= 0;
            endcase 
        end
        case (have_ch)
            1'b1: 
                case (color)
                    8'b00000000: {red,green,blue} = {`WHITH_R,`WHITH_G,`WHITH_B};
                    8'b00000001:{red,green,blue} = {`YELLOW_R,`YELLOW_G,`YELLOW_B};
                    8'b00000010:{red,green,blue} = {`RED_R,`RED_G,`RED_B};
                    8'b00000011:{red,green,blue} = {`PINK_R,`PINK_G,`PINK_B};
                    8'b00000100:{red,green,blue} = {`ORANGE_R,`ORANGE_G,`ORANGE_B};
                    8'b00000101:{red,green,blue} = {`LBLUE_R,`LBLUE_G,`LBLUE_B};
                    8'b00000110:{red,green,blue} ={`DBLUE_R,`DBLUE_G,`DBLUE_B};
                    default: {red,green,blue} = 12'b000000000000;
                endcase
            default: {red,green,blue} = 12'b000000000000;
        endcase
    end





endmodule
