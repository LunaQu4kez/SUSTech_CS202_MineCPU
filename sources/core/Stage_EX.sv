`include "Const.svh"

module Stage_EX (
	input  logic [`ALUOP_WID] ALU_op,
	input  logic              ALU_src,
	input  logic [`DATA_WID ] reg_data1, reg_data2, imm,
	input  logic [`DATA_WID ] EX_MEM_data, MEM_WB_data,
	input  logic [`REGS_WID ] ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd,
	input  logic              EX_MEM_RegWrite, MEM_WB_RegWrite,
	output logic [`DATA_WID ] data_out,
	output logic [`DATA_WID ] result
);

	logic [`DATA_WID] src1, src2, src2_mux;
	logic [`FW_WID  ] fwA, fwB;

	// determine whether to forward
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

	// source of ALU and write address
	assign src2 = ALU_src ? imm : src2_mux;
	assign data_out = src2_mux;

	Forward forward_unit (
		.ID_EX_rs1,
		.ID_EX_rs2,
		.EX_MEM_rd,
		.MEM_WB_rd,
		.EX_MEM_RegWrite,
		.MEM_WB_RegWrite,
		.fwA,
		.fwB
	);

	ALU alu_unit (
		.src1,
		.src2,
		.ALU_op,
		.result
	);

endmodule
