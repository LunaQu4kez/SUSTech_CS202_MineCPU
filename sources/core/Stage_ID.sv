`include "Const.svh"

module Stage_ID (
    input                           clk, rst,
    input  logic [`DATA_WID    ]    pc_in,
    input  logic [`DATA_WID    ]    inst,
    input  logic [`REGS_WID    ]    ID_EX_rd, MEM_WB_rd,
    input  logic [`DATA_WID    ]    data_WB,
    input  logic                    RegWrite,
    input  logic                    ID_EX_MemRead,
    output logic [`DATA_WID    ]    pc_branch,
    output logic                    IF_Flush,
    output logic [`EX_CTRL_WID ]    EX_ctrl,
    output logic [`MEM_CTRL_WID]    MEM_ctrl,
    output logic [`WB_CTRL_WID ]    WB_ctrl,
    output logic [`REGS_WID    ]    rs1_out, rs2_out, rd_out,
    output logic [`DATA_WID    ]    data1, data2, imm_out,
    output logic                    IF_ID_Write, PC_Write,
    output logic                    branch
);

    logic [`DATA_WID] imm;

    ImmGen immgen_inst (
        .inst,
        .imm
    );


    assign pc_branch = pc_in + (imm << 1);
    assign imm_out = imm;


    logic [`REGS_WID] rs1, rs2, rd;
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];
    assign rd = inst[11:7];
    assign rs1_out = rs1;
    assign rs2_out = rs2;
    assign rd_out = rd;

    RegisterFile reg_inst (
        .clk,
        .rst,
        .read_reg_1(rs1),
        .read_reg_2(rs2),
        .write_reg(MEM_WB_rd),
        .write_data(data_WB),
        .RegWrite,
        .read_data_1(data1),
        .read_data_2(data2),
        .branch
    );


    logic stall;

    Hazard hazard (
        .IF_ID_rs1(rs1),
        .IF_ID_rs2(rs2),
        .ID_EX_rd,
        .ID_EX_MemRead,
        .stall,
        .IF_ID_Write,
        .PC_Write
    );


    logic [`CTRL_WID] total_ctrl, ctrl_out;

    Control ctrl_inst (
        .inst,
        .total_ctrl,
        .IF_Flush
    );

    assign ctrl_out = (stall == 1'b0) ? total_ctrl : 0;
    assign EX_ctrl = ctrl_out[8:4];
    assign MEM_ctrl = ctrl_out[3:2];
    assign WB_ctrl = ctrl_out[1:0];

endmodule