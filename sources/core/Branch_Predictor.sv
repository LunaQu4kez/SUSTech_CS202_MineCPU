`include "Const.svh"

module Branch_Predictor (
    input  logic             clk, rst,
    // whether to branch and predict, from Control
    input  logic             branch, predict,
    // process jalr
    input  logic [`DATA_WID] rs1_data,
    input  logic             ujtype,
    // pc, imm is from IF, old_pc is from EX
    input  logic [`DATA_WID] pc, imm, old_pc,
    input  logic             old_predict, old_actual, old_branch,
    // target pc is predicted pc, pass predict_result to EX, predict_fail to flush
    output logic [`DATA_WID] target_pc,
    output logic             predict_result, predict_fail
);
    reg [1:0] History_Table [0: (1 << 12) - 1];
    initial begin
        for (int i = 0; i < (1 << 12); i = i + 1) begin
            History_Table[i] = 2'b00;
        end
    end

    logic [11:0] table_addr;
    assign table_addr = pc[13:2];
    assign predict_fail = old_predict != old_actual;

    always_comb begin // 0: strongly not taken, 1: weakly not taken, 2: weakly taken, 3: strongly taken
        predict_result = History_Table[table_addr] >= 2'b10;
        target_pc = predict_result ? pc + imm : pc + 4;
    end

    always_ff @(posedge clk) begin : Update_Table
        
    end

endmodule
