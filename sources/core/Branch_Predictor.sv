`include "Const.svh"

module Branch_Predictor (
    input  logic             clk, rst,
    // whether to branch and predict, from Control
    input  logic             branch, predict,
    // process jalr, ujtype indicates jal
    input  logic [`DATA_WID] rs1_data,
    input  logic             ujtype,
    // pc is from IF, imm is from ID, old_pc is from EX
    input  logic [`DATA_WID] pc, imm, old_pc,
    input  logic             old_predict, old_actual, old_branch,
    // target pc is predicted pc, pass predict_result to EX, predict_fail to flush
    output logic [`DATA_WID] target_pc,
    output logic             predict_result, predict_fail
);

    reg [1:0] History_Table [0: (1 << 12) - 1];
    reg [1:0] start_flag; // 01: first cycle does nothing, 10: enable pc update

    initial begin
        for (int i = 0; i < (1 << 12); i = i + 1) begin
            History_Table[i] = 2'b01;
        end
    end

    logic [11:0] table_addr; // use pc[13:2] as index since last 2 bits are always 0
    assign table_addr = pc[13:2];
    assign predict_fail = old_predict != old_actual;

    always_ff @(posedge clk) begin
        if (rst) begin
            start_flag <= 2'b00;
        end else if (start_flag == 2'b10) begin
            start_flag <= start_flag;
        end else begin
            start_flag <= start_flag + 1;
        end
    end

    always_comb begin : Predict // 0: strongly not taken, 1: weakly not taken, 2: weakly taken, 3: strongly taken
        if (rst || start_flag != 2'b01) begin
            predict_result = 1'b0;
            target_pc = 0;
        end else if (predict_fail) begin
            predict_result = old_actual;
            target_pc = old_pc;
        end else begin
            unique case ({branch, predict})
                2'b00: begin // no branch, no predict: continue
                    predict_result = 1'b0;
                    target_pc = pc + 4;
                end
                2'b10: begin // branch, no predict: jump
                    predict_result = 1'b1;
                    if (ujtype) target_pc = predict_result ? pc + imm : pc + 4; // jal
                    else target_pc = predict_result ? rs1_data + imm : pc + 4; // jalr
                end
                2'b11: begin // branch, predict: beq, bne, blt, bge, bltu, bgeu
                    predict_result = History_Table[table_addr] > 2'b01;
                    target_pc = predict_result ? pc + imm : pc + 4;
                end
                default: begin // dont care case: continue
                    predict_result = 1'b0;
                    target_pc = pc + 4;
                end
            endcase
        end
    end

    always_ff @(posedge clk) begin : Update_Table
        if (rst) begin
            for (int i = 0; i < (1 << 12); i = i + 1) begin
                History_Table[i] <= 2'b00;
            end
        end else if (old_branch) begin // update table
            if (old_actual) begin
                if (History_Table[table_addr] < 2'b11) begin
                    History_Table[table_addr] <= History_Table[table_addr] + 1;
                end else
                    History_Table[table_addr] <= History_Table[table_addr];
            end else begin
                if (History_Table[table_addr] > 2'b00) begin
                    History_Table[table_addr] <= History_Table[table_addr] - 1;
                end else begin
                    History_Table[table_addr] <= History_Table[table_addr];
                end
            end
        end else begin
            History_Table[table_addr] <= History_Table[table_addr];
        end
    end

endmodule
