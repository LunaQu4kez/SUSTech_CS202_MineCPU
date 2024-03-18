module Mux32bits (
    input [31:0]    in1, in2,
    input           sel,
    output [31:0]   out1
);

    assign out1 = ~sel ? in1 : in2;
    
endmodule