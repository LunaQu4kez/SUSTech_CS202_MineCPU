`include "Seg7Const.svh"

module Seg7Tube(
    input               clk, rst_n,                // clock, reset
    input        [31:0] seg1_in, seg2_in,          // 7-segment display data
    output logic [7:0]  seg_en,                    // scan signal
    output logic [7:0]  seg_out0, seg_out1         // 7-segment display
);

    logic [7:0]  p0, p1, p2, p3, p4, p5, p6, p7;  // data input
    logic        clk_500hz;                       // 500Hz clock
    logic [31:0] cnt;                             // Counter for the 500Hz clock
    logic [2:0]  scan_cnt;                        // Scan signal for the 7-segment display
    logic [7:0]  seg_in0, seg_in1;                // Data for the 7-segment display
    parameter  period = `SEG_FREQ;                // Period of the 500Hz clock
    assign p0 = seg1_in[ 7: 0];
    assign p1 = seg1_in[15: 8];
    assign p2 = seg1_in[23:16];
    assign p3 = seg1_in[31:24];
    assign p4 = seg2_in[ 7: 0];
    assign p5 = seg2_in[15: 8];
    assign p6 = seg2_in[23:16];
    assign p7 = seg2_in[31:24];

    always_comb begin
        case(seg_in0)
            `IN0: seg_out0 = `SEG0; // Display '0'
            `IN1: seg_out0 = `SEG1; // Display '1'
            `IN2: seg_out0 = `SEG2; // Display '2'
            `IN3: seg_out0 = `SEG3; // Display '3'
            `IN4: seg_out0 = `SEG4; // Display '4'
            `IN5: seg_out0 = `SEG5; // Display 'S'
            `IN6: seg_out0 = `SEG6; // Display '6'
            `IN7: seg_out0 = `SEG7; // Display '7'
            `IN8: seg_out0 = `SEG8; // Display '8'
            `IN9: seg_out0 = `SEG9; // Display '9'
            `INA: seg_out0 = `SEGA; // Display 'A'
            `INB: seg_out0 = `SEGB; // Display 'b'
            `INC: seg_out0 = `SEGC; // Display 'C'
            `IND: seg_out0 = `SEGD; // Display 'd'
            `INE: seg_out0 = `SEGE; // Display 'E'
            `INF: seg_out0 = `SEGF; // Display 'F'
         default: seg_out0 = 0;     // Display nothing
        endcase
    end

    always_comb begin
        case(seg_in1)
            `IN0: seg_out1 = `SEG0; // Display '0'
            `IN1: seg_out1 = `SEG1; // Display '1'
            `IN2: seg_out1 = `SEG2; // Display '2'
            `IN3: seg_out1 = `SEG3; // Display '3'
            `IN4: seg_out1 = `SEG4; // Display '4'
            `IN5: seg_out1 = `SEG5; // Display 'S'
            `IN6: seg_out1 = `SEG6; // Display '6'
            `IN7: seg_out1 = `SEG7; // Display '7'
            `IN8: seg_out1 = `SEG8; // Display '8'
            `IN9: seg_out1 = `SEG9; // Display '9'
            `INA: seg_out1 = `SEGA; // Display 'A'
            `INB: seg_out1 = `SEGB; // Display 'b'
            `INC: seg_out1 = `SEGC; // Display 'C'
            `IND: seg_out1 = `SEGD; // Display 'd'
            `INE: seg_out1 = `SEGE; // Display 'E'
            `INF: seg_out1 = `SEGF; // Display 'F'
         default: seg_out1 = 0;     // Display nothing
        endcase
    end

    // Generate the 500Hz clock
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            clk_500hz <= 0;
            cnt <= 0;
        end
        else begin
            if (cnt == (period >> 1) - 1) begin
                clk_500hz <= ~clk_500hz;
                cnt <= 32'd0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    // Generate the scan signal
    always @(posedge clk_500hz, negedge rst_n) begin
        if (!rst_n) begin
            scan_cnt <= 0;
        end else begin
            if (scan_cnt == 3'd7) begin
                scan_cnt <= 0;
            end else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end

    // Control the 7-segment display
    always @(*) begin
        case (scan_cnt)
            3'b000: begin seg_en = 8'b00000001; seg_in0 = p0; seg_in1 = p0; end
            3'b001: begin seg_en = 8'b00000010; seg_in0 = p1; seg_in1 = p1; end
            3'b010: begin seg_en = 8'b00000100; seg_in0 = p2; seg_in1 = p2; end
            3'b011: begin seg_en = 8'b00001000; seg_in0 = p3; seg_in1 = p3; end
            3'b100: begin seg_en = 8'b00010000; seg_in0 = p4; seg_in1 = p4; end
            3'b101: begin seg_en = 8'b00100000; seg_in0 = p5; seg_in1 = p5; end
            3'b110: begin seg_en = 8'b01000000; seg_in0 = p6; seg_in1 = p6; end
            3'b111: begin seg_en = 8'b10000000; seg_in0 = p7; seg_in1 = p7; end
            default: seg_en = 8'b00000000;
        endcase
    end
endmodule
