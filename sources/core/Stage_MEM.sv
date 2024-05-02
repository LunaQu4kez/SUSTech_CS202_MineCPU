`include "Const.svh"

module Stage_MEM (
    input                        clk, rst,
    input  logic [`MEM_CTRL_WID] MEM_ctrl_in,
	input  logic [`WB_CTRL_WID ] WB_ctrl_in,
    input  logic [`DATA_WID    ] write_addr,
    input  logic [`DATA_WID    ] write_data,
    input  logic [`REGS_WID    ] EX_MEM_rd,
    output logic [`REGS_WID    ] MEM_rd_out,
    output logic [`DATA_WID    ] addr_out,
    output logic [`DATA_WID    ] data_out,
    output logic [`WB_CTRL_WID ] WB_ctrl_out,
    output logic                 dcache_stall,
    // interact with Memory
    input  logic [`DATA_WID    ] mem_data,
    output logic [`DATA_WID    ] mem_addr,
    output logic [`DATA_WID    ] mem_write_data,
    output logic                 mem_web
);

    wire MemWrite;
    wire [`LDST_WID] ldst;
    assign WB_ctrl_out = WB_ctrl_in;
    assign MEM_rd_out = EX_MEM_rd;
    assign addr_out = write_addr;
    assign MemWrite = MEM_ctrl_in[1];
    assign ldst = MEM_ctrl_in[4:2];

    DCache dcache_inst (
        .clk,
        .rst,
        .addr(write_addr),
        .data_out,
        .write_data,
        .ldst,
        .MemWrite,
        .dcache_stall,
        .mem_data,
        .mem_addr,
        .mem_write_data,
        .mem_web
    );

endmodule
