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
    wire [127:0] temp_ch;
    wire have_ch0;
    wire flag = hc0 > 15 && hc0 < 784 && vc0 > 43 && vc0 < 556;

    assign char_addr = (hc0-16)%8 + ((vc0-44)%16)*8;
    assign x = (hc0-16) >> 3;
    assign y = (vc0-44) >> 4;
    assign vga_addr = 96*y+ x;
    assign have_ch0 = have_ch[char_addr];

    always @(posedge active) begin
        have_ch <= temp_ch;
    end

    always_comb begin
        case (color)
            8'b00000000: {red,green,blue} = have_ch0 ? {`WHITH_R,`WHITH_G,`WHITH_B} : 12'h000;
            8'b00000001:{red,green,blue} = have_ch0 ? {`YELLOW_R,`YELLOW_G,`YELLOW_B} : 12'h000;
            8'b00000010:{red,green,blue} = have_ch0 ? {`RED_R,`RED_G,`RED_B} : 12'h000;
            8'b00000011:{red,green,blue} = have_ch0 ? {`PINK_R,`PINK_G,`PINK_B} : 12'h000;
            8'b00000100:{red,green,blue} = have_ch0 ? {`ORANGE_R,`ORANGE_G,`ORANGE_B} : 12'h000;
            8'b00000101:{red,green,blue} = have_ch0 ? {`LBLUE_R,`LBLUE_G,`LBLUE_B} : 12'h000;
            8'b00000110:{red,green,blue} = have_ch0 ? {`DBLUE_R,`DBLUE_G,`DBLUE_B} : 12'h000;
            default: {red,green,blue} = 12'b000000000000;
        endcase
    end

    always_comb begin
        case (ch)
            0: temp_ch = `CHAR_0; 
            default: temp_ch = 8'h00;
        endcase
    end



endmodule
