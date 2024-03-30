module InstMem (
    input              clk,
    input  [`DATA_WID] addr,
    output [`DATA_WID] inst
);

    progrom instmem (
        .clka(~clk),
        .addra(addr[15:2]),
        .douta(inst)
    );
    
endmodule
