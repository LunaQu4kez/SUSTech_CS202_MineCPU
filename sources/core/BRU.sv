module BRU (
	input  logic [`DATA_WID] src1, src2,
	input  logic [`BRU_OP  ] op,
	output logic [`DATA_WID] result
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
		     default: result = 0;
		endcase
	end

endmodule