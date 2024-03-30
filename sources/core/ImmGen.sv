`include "Const.svh"

module ImmGen (
    input  logic [`DATA_WID] inst,
    output logic [`DATA_WID] imm
);

always_comb begin
    if (inst[6:0] == `ART_IMM_OP | inst[6:0] == `LOAD_OP | inst[6:0] == `JALR_OP) begin   // I type
        imm[11:0] = inst[31:20];
        if (inst[31] == 0) begin
            imm[31:12] = 20'b0000_0000_0000_0000_0000;
        end
        else begin
            imm[31:12] = 20'b1111_1111_1111_1111_1111;
        end
    end
    else if (inst[6:0] == `STORE_OP) begin        // S type
        imm[11:0] = {inst[31:25], inst[11:7]};
        if (inst[31] == 0) begin
            imm[31:12] = 20'b0000_0000_0000_0000_0000;
        end
        else begin
            imm[31:12] = 20'b1111_1111_1111_1111_1111;
        end
    end
    else if (inst[6:0] == `BRANCH_OP) begin        // B type
        imm[12:0] = {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
        if (inst[31] == 0) begin
            imm[31:13] = 19'b0000_0000_0000_0000_000;
        end
        else begin
            imm[31:13] = 19'b1111_1111_1111_1111_111;
        end
    end
    else if (inst[6:0] == `LUI_OP | inst[6:0] == `AUIPC_OP) begin        // U type
        imm[31:12] = inst[31:12];
        imm[11:0] = 12'b0000_0000_0000;
    end
    else if (inst[6:0] == `JAL_OP) begin        // J type
        imm[20:0] = {inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
        if (inst[31] == 0) begin
            imm[31:21] = 11'b0000_0000_000;
        end
        else begin
            imm[31:21] = 11'b1111_1111_111;
        end
    end
    else begin                                     // R type and others
        imm[31:0] = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    end
end

    
endmodule