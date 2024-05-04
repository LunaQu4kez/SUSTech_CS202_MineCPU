`include "Const.svh"

module ID_EX (
    input                  clk, rst,
    input  [`DATA_WID    ] pc_in, data1_in, data2_in, imm_in,
    input  [`REGS_WID    ] rd_in,              // inst[11-7], rd_in
    input  [`REGS_WID    ] rs1_in, rs2_in,     // ID_EX_rs1, ID_EX_rs2
    input                  flush,              // control hazard flush, 1 yes, 0 no
    input                  predict_result_in,
    input                  dcache_stall, icache_stall,
    output [`DATA_WID    ] pc_out, data1_out, data2_out, imm_out,
    output [`REGS_WID    ] rd_out,             // inst[11-7], rd_out
    output [`REGS_WID    ] rs1_out, rs2_out,   // ID_EX_rs1, ID_EX_rs2
    output                 predict_result_out,
    // Control related
    input  [`EX_CTRL_WID ] EX_ctrl_in,
    input  [`MEM_CTRL_WID] MEM_ctrl_in,
    input  [`WB_CTRL_WID ] WB_ctrl_in,
    output [`EX_CTRL_WID ] EX_ctrl_out,
    output [`MEM_CTRL_WID] MEM_ctrl_out,
    output [`WB_CTRL_WID ] WB_ctrl_out
);

    reg [`DATA_WID] pc = 0;
    reg [`DATA_WID] data1 = 0;
    reg [`DATA_WID] data2 = 0;
    reg [`DATA_WID] imm = 0;
    reg [`REGS_WID] rd = 0;
    reg [`REGS_WID] rs1 = 0;
    reg [`REGS_WID] rs2 = 0;
    reg predict_result = 0;
    reg [`EX_CTRL_WID]  EX_ctrl = 0;
    reg [`MEM_CTRL_WID] MEM_ctrl = 0;
    reg [`WB_CTRL_WID]  WB_ctrl = 0;
    assign pc_out = pc;
    assign data1_out = data1;
    assign data2_out = data2;
    assign imm_out = imm;
    assign rd_out = rd;
    assign rs1_out = rs1;
    assign rs2_out = rs2;
    assign EX_ctrl_out = EX_ctrl;
    assign MEM_ctrl_out = MEM_ctrl;
    assign WB_ctrl_out = WB_ctrl;
    assign predict_result_out = predict_result;

    always @(posedge clk) begin
        if (rst | flush) begin
            pc <= 0;
            data1 <= 0;
            data2 <= 0;
            imm <= 0;
            rd <= 0;
            rs1 <= 0;
            rs2 <= 0;
            EX_ctrl <= 0;
            MEM_ctrl <= 0;
            WB_ctrl <= 0;
            predict_result <= 0;
        end else if (dcache_stall | icache_stall) begin
            pc <= pc;
            data1 <= data1;
            data2 <= data2;
            imm <= imm;
            rd <= rd;
            rs1 <= rs1;
            rs2 <= rs2;
            EX_ctrl <= EX_ctrl;
            MEM_ctrl <= MEM_ctrl;
            WB_ctrl <= WB_ctrl;
            predict_result <= predict_result;
        end else begin
            pc <= pc_in;
            data1 <= data1_in;
            data2 <= data2_in;
            imm <= imm_in;
            rd <= rd_in;
            rs1 <= rs1_in;
            rs2 <= rs2_in;
            EX_ctrl <= EX_ctrl_in;
            MEM_ctrl <= MEM_ctrl_in;
            WB_ctrl <= WB_ctrl_in;
            predict_result <= predict_result_in;
        end
    end
    
endmodule
