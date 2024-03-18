module InstMem (
    input           clk,
    input [31:0]    addr,
    output [31:0]   inst
);

    progrom instmem (
        .clka(~clk),
        .addra(addr[15:2]),
        .douta(inst)
    );
    
endmodule
