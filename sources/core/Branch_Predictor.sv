`include "Const.svh"

module Branch_Predictor (
    input  logic             clk, rst,
    input  logic             stall,
    // whether to branch and predict, from Control
    input  logic             branch, predict,
    // process jalr, ujtype indicates jal
    input  logic [`DATA_WID] rs1_data,
    input  logic             ujtype,
    input  logic [`REGS_WID] rs1, rd,
    // process exception
    input  logic             excp,
    // pc is from IF, imm is from ID, old_pc is from EX
    input  logic [`DATA_WID] pc, imm, old_pc, old_branch_pc,
    input  logic             old_predict, old_actual, old_branch,
    // target pc is predicted pc, pass predict_result to EX, predict_fail to flush
    output logic [`DATA_WID] target_pc,
    output logic             predict_result, predict_fail,
    // sepc
    output logic [`DATA_WID] sepc
);

    reg [`BHT_WID ] History_Table [0: (1 << 10) - 1]; // BHT/PHT
    reg [`DATA_WID] Return_Addr   [0: (1 <<  7) - 1]; // RAS
    reg [`RAS_WID ] RAS_top = 0; // RAS top pointer
    reg start_flag = 0; // 0: first cycle does nothing, 1: enable pc update

    logic [`DATA_WID] target_pc0;
    wire  [`DATA_WID] pc_plus_4 = pc + 4;
    assign target_pc = excp ? `EXCP_ADDR : target_pc0;

    initial begin
        for (int i = 0; i < (1 << 10); i = i + 1) begin
            History_Table[i] = 2'b01;
        end
    end

    always_ff @(negedge clk) begin
        if (rst) sepc <= 0;
        else if (excp) sepc <= pc_plus_4;
        else sepc <= sepc;
    end

    logic [9:0] table_addr, update_addr; // use pc[11:2] as index since last 2 bits are always 0
    assign table_addr  = pc[11:2];
    assign update_addr = old_branch_pc[11:2];
    assign predict_fail = old_predict != old_actual;

    always_ff @(posedge clk) begin
        if (rst) begin
            start_flag <= 0;
        end else begin
            start_flag <= 1;
        end
    end

    always_comb begin : Predict // 0: strongly not taken, 1: weakly not taken, 2: weakly taken, 3: strongly taken
        if (rst || ~start_flag) begin
            predict_result = 1'b0;
            target_pc0 = 0;
        end else if (predict_fail) begin
            predict_result = old_actual;
            target_pc0 = old_pc;
        end else begin
            unique case ({branch, predict})
                2'b00: begin // no branch, no predict: continue
                    predict_result = 1'b0;
                    target_pc0 = pc_plus_4;
                end
                2'b10: begin // branch, no predict: jump
                    predict_result = 1'b1;
                    if (ujtype) target_pc0 = pc + imm; // jal(call rd == 1)
                    else target_pc0 = (rs1 == 1) ? Return_Addr[RAS_top] : rs1_data + imm;  // jalr(ret rs1 == 1)
                end
                2'b11: begin // branch, predict: beq, bne, blt, bge, bltu, bgeu
                    predict_result = History_Table[table_addr] > 2'b01;
                    target_pc0 = predict_result ? pc + imm : pc_plus_4;
                end
                default: begin // dont care case: continue
                    predict_result = 1'b0;
                    target_pc0 = pc_plus_4;
                end
            endcase
        end
    end

    always_ff @(posedge clk) begin : Update_Table
        if (rst) begin
            for (int i = 0; i < (1 << 10); i = i + 1) begin
                History_Table[i] <= 2'b01;
            end
        end else if (old_branch && !stall) begin // update table
            if (old_actual) begin
                if (History_Table[update_addr] != 2'b11) begin
                    History_Table[update_addr] <= History_Table[update_addr] + 1;
                end else
                    History_Table[update_addr] <= History_Table[update_addr];
            end else begin
                if (History_Table[update_addr] != 2'b00) begin
                    History_Table[update_addr] <= History_Table[update_addr] - 1;
                end else begin
                    History_Table[update_addr] <= History_Table[update_addr];
                end
            end
        end else begin
            History_Table[update_addr] <= History_Table[update_addr];
        end
    end

    always_ff @(posedge clk) begin : Update_RAS
        if (rst || ~start_flag) begin
            RAS_top <= 0;
        end else if ({branch, predict} == 2'b10 && !stall) begin
            if (rd == 1) begin // push return address
                Return_Addr[RAS_top + 1] <= pc_plus_4;
                RAS_top <= RAS_top + 1;
            end else if (rs1 == 1) begin // pop return address
                RAS_top <= RAS_top - 1;
            end else begin
                RAS_top <= RAS_top;
            end
        end else begin
            RAS_top <= RAS_top;
        end
    end

endmodule
