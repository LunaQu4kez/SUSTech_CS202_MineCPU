module DataMem (
    input               clk, rst,
    input [31:0]        addr, write_data, 
    input               MemRead, MemWrite,
    output [31:0]       read_data
);

    RAM ram(
        .clka(~clk),
        .addra(addr[15:2]),
        .dina(write_data),
        .douta(read_data),
        .wea(MemWrite)
    );





endmodule