module Mux32bits (
    input  [`DATA_WID] in1, in2,
    input              sel,
    output [`DATA_WID] out
);

assign out = ~sel ? in1 : in2;

endmodule