module ALU_Sim ();
    
    logic [31:0] src1, src2;
    logic [3:0] ALU_op;
    logic [31:0] result;

    ALU alu_inst (
        .src1,
        .src2,
        .ALU_op,
        .result
    );

    initial begin
        src1 = 32'h3600000e;
        src2 = 32'h00000100;
        ALU_op = 14;
        #20 ALU_op = 15;
        #20 ALU_op = 10;
        #20 ALU_op = 11;
        #20 ALU_op = 12;
        #20 ALU_op = 13;
        #20 ALU_op = 10;
        #20 ALU_op = 11;
        #20 ALU_op = 12;
        #20 ALU_op = 13;
    end

    initial fork
        #40 src1 = 32'h08000000;
        #120 src1 = 32'h000000ef;
    join

    initial fork
        #40 src2 = 32'h10000000;
        #120 src2 = 32'h0000a001;
    join

endmodule