module Control (
    input [6:0]         inst,
    output              Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output [3:0]        ALUOp
);

endmodule