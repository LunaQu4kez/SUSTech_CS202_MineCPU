module BRU (
	input  logic [`DATA_WID] src1, src2, pc, imm,
	input  logic [`BRU_OP  ] op,
	output logic [`DATA_WID] result, pc_out
);
	always_comb begin : BRU
		unique case (op)
			`BRU_NOP: result = 0;
			 `BRU_EQ: result = (src1 == src2);
			 `BRU_NE: result = (src1 != src2);
			 `BRU_LT: result = ($signed(src1) < $signed(src2));
			 `BRU_GE: result = ($signed(src1) >= $signed(src2));
			`BRU_LTU: result = (src1 < src2);
			`BRU_GEU: result = (src1 >= src2);
			`BRU_JMP: result = 1;
		     default: result = 0;
		endcase
	end

	always_comb begin : Actual_PC
		unique case (result)
			1'b0: pc_out = pc + 4; // not taken
			1'b1: pc_out = pc + imm; // taken
		 default: pc_out = 0;
		endcase
	end

endmodule