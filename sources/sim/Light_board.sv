module Light_board (
    input [7:0] switches1, switches2, switches3,
    output [7:0] led1_out, led2_out, led3_out
);

    assign led1_out = switches1;
    assign led2_out = switches2;
    assign led3_out = switches3;

endmodule