`include "Const.svh"

// toDo: add 3 states control signals: 
// EX_ctrl: ALU_op(y), ALU_scr(y) 
// MEM_ctrl: MemWrite(n), MemRead(n)
// WB_ctrl: RegWrite(n), MemtoReg(n)
module Stage_EX(
	input  logic              clk, rst,
	input  logic [`ALUOP_WID] ALU_op,
	input  logic              ALU_src,
	input  logic [`DATA_WID ] reg_data1, reg_data2, imm,
	input  logic [`DATA_WID ] EX_MEM_data, MEM_WB_data,
	input  logic [`REGS_WID ] ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd,
	input  logic              EX_MEM_RegWrite, MEM_WB_RegWrite,
	output logic [`DATA_WID ] data_out,
	output logic [`DATA_WID ] write_addr
);

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