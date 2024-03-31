`include "Const.svh"

module Hazard (
    input  logic [`REGS_WID] IF_ID_rs1, IF_ID_rs2, ID_EX_rd,
    input  logic             ID_EX_MemRead,
    output logic             stall, IF_ID_Write, PC_Write  // 1 stall, 0 not stall
);

    always_comb begin
        if (ID_EX_MemRead &
            ((ID_EX_rd == IF_ID_rs1) | (ID_EX_rd == IF_ID_rs2))) begin  // stall
            stall = 1'b1;
            IF_ID_Write = 1'b1;
            PC_Write = 1'b1;
        end
        else begin   // not stall
            stall = 1'b0;
            IF_ID_Write = 1'b0;
            PC_Write = 1'b0;
        end
    end

endmodule