`include "Const.svh"

// add 3 states control signals: 
// EX_ctrl_in: ALU_op(y), ALU_scr(y) 
// MEM_ctrl_in: MemWrite(n), MemRead(n)
// WB_ctrl_in: RegWrite(n), MemtoReg(n)
module Stage_EX(
	input  logic              	 clk, rst,
	input  logic [`EX_CTRL_WID]  EX_ctrl_in,
	input  logic [`MEM_CTRL_WID] MEM_ctrl_in,
	input  logic [`WB_CTRL_WID]  WB_ctrl_in,
	input  logic [`DATA_WID ] 	 reg_data1, reg_data2, imm,
	input  logic [`DATA_WID ] 	 EX_MEM_data, MEM_WB_data,
	input  logic [`REGS_WID ] 	 ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd,
	input  logic              	 EX_MEM_RegWrite, MEM_WB_RegWrite,
	output logic [`DATA_WID ] 	 data_out,
	output logic [`DATA_WID ] 	 write_addr,
	output logic [`MEM_CTRL_WID] MEM_ctrl_out,
	output logic [`WB_CTRL_WID]  WB_ctrl_out
);

	logic [`ALUOP_WID] ALU_op;
	logic ALU_src;

	assign ALU_op = EX_ctrl_in[4:1];
	assign ALU_src = EX_ctrl_in[0];

	assign MEM_ctrl_out = MEM_ctrl_in;
	assign WB_ctrl_out = WB_ctrl_in;

	logic [`DATA_WID] src1, src2, src2_mux;
	logic [`FW_WID  ] fwA, fwB;

	always_comb begin : Mux_A
		unique case (fwA)
			2'b00: src1 = reg_data1;
			2'b01: src1 = MEM_WB_data;
			2'b10: src1 = EX_MEM_data;
		  default: src1 = 0;
		endcase
	end

	always_comb begin : Mux_B
		unique case (fwB)
			2'b00: src2_mux = reg_data2;
			2'b01: src2_mux = MEM_WB_data;
			2'b10: src2_mux = EX_MEM_data;
		  default: src2_mux = 0;
		endcase
	end

	assign src2 = ALU_src ? imm : src2_mux;

	Forward forward_unit(
		.ID_EX_rs1,
		.ID_EX_rs2,
		.EX_MEM_rd,
		.MEM_WB_rd,
		.EX_MEM_RegWrite,
		.MEM_WB_RegWrite,
		.fwA,
		.fwB
	);

	ALU alu_unit(
		.src1,
		.src2,
		.ALU_op,
		.res(data_out)
	);
	
endmodule