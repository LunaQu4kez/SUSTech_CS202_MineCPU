`include "Const.svh"

module Keyboard (
    input  logic [`KBPIN_WID ] kp,
    output logic [`KBCODE_WID] kb_idx
);

    always_comb begin
        unique case (kp) 
            8'b00010001: kb_idx = 5'b10001; // 1
            8'b00100001: kb_idx = 5'b10010; // 2
            8'b01000001: kb_idx = 5'b10011; // 3
            8'b10000001: kb_idx = 5'b11010; // A(10)
            8'b00010010: kb_idx = 5'b10100; // 4
            8'b00100010: kb_idx = 5'b10101; // 5
            8'b01000010: kb_idx = 5'b10110; // 6
            8'b10000010: kb_idx = 5'b11011; // B(11)
            8'b00010100: kb_idx = 5'b10111; // 7
            8'b00100100: kb_idx = 5'b11000; // 8
            8'b01000100: kb_idx = 5'b11001; // 9
            8'b10000100: kb_idx = 5'b11100; // C(12)
            8'b00011000: kb_idx = 5'b11110; // *(14)
            8'b00101000: kb_idx = 5'b10000; // 0
            8'b01001000: kb_idx = 5'b11111; // #(15)
            8'b10001000: kb_idx = 5'b11011; // D(13)
            default:     kb_idx = 5'b00000; // no
        endcase
    end
    
endmodule