`include "Const.svh"

module Forward (
    input  logic [`REGS_WID] ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd,
    input  logic             EX_MEM_RegWrite, MEM_WB_RegWrite,
    output logic [`FW_WID  ] fwA, fwB // 00: no fwd, 01: from MEM/WB, 10: from EX/MEM
);

    always_comb begin : ForwardA
        if (EX_MEM_RegWrite
            & (EX_MEM_rd != 0)
            & (EX_MEM_rd == ID_EX_rs1)) begin
            fwA = 2'b10;
        end
        else if (MEM_WB_RegWrite
                & (MEM_WB_rd != 0)
                & ~(EX_MEM_RegWrite & (EX_MEM_rd != 0) & (EX_MEM_rd == ID_EX_rs1))
                & (MEM_WB_rd == ID_EX_rs1)) begin
            fwA = 2'b01;
        end
        else begin
            fwA = 2'b00;
        end
    end
    
    always_comb begin : ForwardB
        if (EX_MEM_RegWrite
            & (EX_MEM_rd != 0)
            & (EX_MEM_rd == ID_EX_rs2)) begin
            fwB = 2'b10;
        end
        else if (MEM_WB_RegWrite
                & (MEM_WB_rd != 0)
                & ~(EX_MEM_RegWrite & (EX_MEM_rd != 0) & (EX_MEM_rd == ID_EX_rs2))
                & (MEM_WB_rd == ID_EX_rs2)) begin
            fwB = 2'b01;
        end
        else begin
            fwB = 2'b00;
        end
    end

endmodule