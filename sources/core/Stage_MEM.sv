`include "Const.svh"

module Stage_MEM (
    input  logic [`MEM_CTRL_WID] MEM_ctrl_in,
	input  logic [`WB_CTRL_WID ] WB_ctrl_in,
    input  logic [`DATA_WID    ] write_addr,
    input  logic [`DATA_WID    ] write_data,
    input  logic [`REGS_WID    ] EX_MEM_rd,
	output logic [`REGS_WID    ] EX_MEM_rd_out,
    output logic [`REGS_WID    ] EX_rd_out,
    output logic [`DATA_WID    ] EX_MEM_data_out,
    output logic [`DATA_WID    ] addr_out,
    output logic [`DATA_WID    ] data_out,
    output logic              	 EX_MEM_RegWrite_out,
    output logic [`WB_CTRL_WID ] WB_ctrl_out,
    // interact with Memory
    output logic [`DATA_WID    ] mem_addr,
    output logic [`DATA_WID    ] mem_write_data,
    output                       MemWrite,
    output                       MemRead,
    input  logic [`DATA_WID    ] mem_data
);

    assign WB_ctrl_out = WB_ctrl_in;
    assign EX_MEM_rd_out = EX_MEM_rd;
    assign EX_rd_out = EX_MEM_rd;
    assign EX_MEM_data_out = write_addr;
    assign addr_out = write_addr;
    assign data_out = mem_data;
    assign EX_MEM_RegWrite_out = WB_ctrl_in[1];

    assign mem_addr = write_addr;
    assign mem_write_data = write_data;
    assign MemWrite = MEM_ctrl_in[1];
    assign MemRead = MEM_ctrl_in[0];

endmodule