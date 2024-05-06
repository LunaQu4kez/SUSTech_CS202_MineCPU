`include "Const.svh"

module Seg7Tube(
    input               clk, rst_n,                // clock, reset
    input        [31:0] data_in,                   // 7-segment display data
    output logic [7:0]  seg_en,                    // scan signal
    output logic [7:0]  seg_out                    // 7-segment display
);

    logic [3:0]  p0, p1, p2, p3, p4, p5, p6, p7;  // data input
    logic        clk_500hz;                       // 500Hz clock
    logic [31:0] cnt;                             // Counter for the 500Hz clock
    logic [2:0]  scan_cnt;                        // Scan signal for the 7-segment display
    logic [7:0]  seg_in;                          // Data for the 7-segment display
    parameter  period = `SEG_FREQ;                // Period of the 500Hz clock
    assign p0 = data_in[3:0];
    assign p1 = data_in[7:4];
    assign p2 = data_in[11:8];
    assign p3 = data_in[15:12];
    assign p4 = data_in[19:16];
    assign p5 = data_in[23:20];
    assign p6 = data_in[27:24];
    assign p7 = data_in[31:28];

    always_comb begin
        case(seg_in)
            `IN0: seg_out = `SEG0; // Display '0'
            `IN1: seg_out = `SEG1; // Display '1'
            `IN2: seg_out = `SEG2; // Display '2'
            `IN3: seg_out = `SEG3; // Display '3'
            `IN4: seg_out = `SEG4; // Display '4'
            `IN5: seg_out = `SEG5; // Display 'S'
            `IN6: seg_out = `SEG6; // Display '6'
            `IN7: seg_out = `SEG7; // Display '7'
            `IN8: seg_out = `SEG8; // Display '8'
            `IN9: seg_out = `SEG9; // Display '9'
            `INA: seg_out = `SEGA; // Display 'A'
            `INB: seg_out = `SEGB; // Display 'b'
            `INC: seg_out = `SEGC; // Display 'C'
            `IND: seg_out = `SEGD; // Display 'd'
            `INE: seg_out = `SEGE; // Display 'E'
            `INF: seg_out = `SEGF; // Display 'F'
         default: seg_out = 0;     // Display nothing
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
            3'b000: begin seg_en = 8'b00000001; seg_in = p0; end
            3'b001: begin seg_en = 8'b00000010; seg_in = p1; end
            3'b010: begin seg_en = 8'b00000100; seg_in = p2; end
            3'b011: begin seg_en = 8'b00001000; seg_in = p3; end
            3'b100: begin seg_en = 8'b00010000; seg_in = p4; end
            3'b101: begin seg_en = 8'b00100000; seg_in = p5; end
            3'b110: begin seg_en = 8'b01000000; seg_in = p6; end
            3'b111: begin seg_en = 8'b10000000; seg_in = p7; end
            default: seg_en = 8'b00000000;
        endcase
    end
endmodule
