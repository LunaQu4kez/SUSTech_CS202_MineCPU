`include "Const.svh"

module CPU (
    input  logic        cpuclk, memclk, rst_n,
    // uart related
    input  logic [31:0] uart_data,
    input  logic [31:0] uart_addr,
    input  logic        uart_done,
    // interact with devices
    input  logic [7:0 ] switches1, switches2, switches3,
    input  logic        bt1, bt2, bt3, bt4, bt5,
    output logic [7:0 ] led1_out, led2_out, led3_out,
    // debug use
    output logic [31:0]         pc_t,
    output logic [31:0]         inst_t,
    output logic [31:0]         EX_data1_t,
    output logic [31:0]         EX_data2_t,
    output logic [31:0]         EX_imm_t,
    output logic [31:0]         MEM_addr_t,
    output logic [31:0]         MEM_data_t,
    output logic [31:0]         WB_data_t,
    output logic [31:0]         WB_mem_t,
    output logic [31:0]         WB_data_ot,
    output logic [31:0]         sepc_t
);

    logic PC_Write, rst;
    logic [`DATA_WID] new_pc, IF_pc_in;
    assign rst = ~rst_n | ~uart_done;

    PC pc_inst (
        .clk(cpuclk),
        .rst,
        .PC_Write,
        .new_pc,
        .pc_out(IF_pc_in)
    );

    logic [`DATA_WID] IF_pc_out, IF_inst_out, mem_pc, mem_inst;

    Stage_IF if_inst (
        .new_pc(IF_pc_in),
        .pc_out(IF_pc_out),
        .inst(IF_inst_out),
        .mem_inst,
        .mem_pc
    );

    logic IF_ID_Write, predict_fail;
    logic flush /*verilator public*/;
    logic [`DATA_WID] ID_inst_in, ID_pc_in;

    IF_ID if_id_inst (
        .clk(cpuclk),
        .rst,
        .inst_in(IF_inst_out),
        .pc_in(IF_pc_out),
        .inst_out(ID_inst_in),
        .pc_out(ID_pc_in)
    );

    logic [`REGS_WID] ID_EX_rd, MEM_WB_rd;
    logic EX_old_predict_out, EX_old_branch_out, EX_branch_result_out;
    logic ID_EX_MemRead, MEM_WB_RegWrite;
    logic [`DATA_WID] EX_old_pc_out, WB_data_out, ID_old_branch_pc;
    logic [`EX_CTRL_WID] IF_EX_ctrl_out;
    logic [`MEM_CTRL_WID] IF_MEM_ctrl_out;
    logic [`WB_CTRL_WID] IF_WB_ctrl_out;
    logic [`REGS_WID] ID_rs1_out, ID_rs2_out, ID_rd_out;
    logic [`DATA_WID] ID_data1_out, ID_data2_out, ID_imm_out, ID_pc_out;
    logic ID_predict_result_out;
    logic [`DATA_WID] sepc;


    Stage_ID id_inst (
        .clk(cpuclk),
        .rst,
        .pc_in(ID_pc_in),
        .inst(ID_inst_in),
        .ID_EX_rd,
        .MEM_WB_rd,
        .old_predict(EX_old_predict_out),
        .old_branch(EX_old_branch_out),
        .branch_result(EX_branch_result_out),
        .old_pc(EX_old_pc_out),
        .old_branch_pc(ID_old_branch_pc),
        .ID_EX_MemRead,
        .data_WB(WB_data_out),
        .RegWrite(MEM_WB_RegWrite),
        .EX_ctrl(IF_EX_ctrl_out),
        .MEM_ctrl(IF_MEM_ctrl_out),
        .WB_ctrl(IF_WB_ctrl_out),
        .rs1_out(ID_rs1_out),
        .rs2_out(ID_rs2_out),
        .rd_out(ID_rd_out),
        .reg_data1(ID_data1_out),
        .reg_data2(ID_data2_out),
        .imm_out(ID_imm_out),
        .pc_out(ID_pc_out),
        .IF_ID_Write,
        .PC_Write,
        .predict_result(ID_predict_result_out),
        .predict_fail,
        .new_pc,
        .sepc
    );

    logic [`DATA_WID] EX_pc_in, EX_data1_in, EX_data2_in, EX_imm_in;
    logic [`REGS_WID] EX_rd_in, EX_rs1_in, EX_rs2_in;
    logic EX_predict_result_in;
    logic [`EX_CTRL_WID] EX_EX_ctrl_in;
    logic [`MEM_CTRL_WID] EX_MEM_ctrl_in;
    logic [`WB_CTRL_WID] EX_WB_ctrl_in;

    assign flush = predict_fail | IF_ID_Write;
    assign ID_old_branch_pc = EX_pc_in;

    ID_EX id_ex_inst (
        .clk(cpuclk),
        .rst,
        .pc_in(ID_pc_out),
        .data1_in(ID_data1_out),
        .data2_in(ID_data2_out),
        .imm_in(ID_imm_out),
        .rd_in(ID_rd_out),
        .rs1_in(ID_rs1_out),
        .rs2_in(ID_rs2_out),
        .flush,
        .predict_result_in(ID_predict_result_out),
        .pc_out(EX_pc_in),
        .data1_out(EX_data1_in),
        .data2_out(EX_data2_in),
        .imm_out(EX_imm_in),
        .rd_out(EX_rd_in),
        .rs1_out(EX_rs1_in),
        .rs2_out(EX_rs2_in),
        .predict_result_out(EX_predict_result_in),
        .EX_ctrl_in(IF_EX_ctrl_out),
        .MEM_ctrl_in(IF_MEM_ctrl_out),
        .WB_ctrl_in(IF_WB_ctrl_out),
        .EX_ctrl_out(EX_EX_ctrl_in),
        .MEM_ctrl_out(EX_MEM_ctrl_in),
        .WB_ctrl_out(EX_WB_ctrl_in)
    );

    logic [`DATA_WID] MEMtoEX_data;
    logic [`REGS_WID] MEM_rd_in, EX_rd_out;
    logic EX_MEM_RegWrite;
    logic [`DATA_WID] EX_data_out, EX_ALU_res_out;
    logic [`MEM_CTRL_WID] EX_MEM_ctrl_out;
    logic [`WB_CTRL_WID] EX_WB_ctrl_out;

    Stage_EX ex_inst (
        .EX_ctrl_in(EX_EX_ctrl_in),
        .MEM_ctrl_in(EX_MEM_ctrl_in),
        .WB_ctrl_in(EX_WB_ctrl_in),
        .reg_data1(EX_data1_in),
        .reg_data2(EX_data2_in),
        .imm(EX_imm_in),
        .pc(EX_pc_in),
        .EX_MEM_data(MEMtoEX_data),
        .MEM_WB_data(WB_data_out),
        .ID_EX_rs1(EX_rs1_in),
        .ID_EX_rs2(EX_rs2_in),
        .ID_EX_rd(EX_rd_in),
        .EX_MEM_rd(MEM_rd_in),
        .MEM_WB_rd,
        .EX_MEM_RegWrite,
        .MEM_WB_RegWrite,
        .old_predict_in(EX_predict_result_in),
        .data_out(EX_data_out),
        .write_addr(EX_ALU_res_out),
        .EX_rd_out,
        .MEM_ctrl_out(EX_MEM_ctrl_out),
        .WB_ctrl_out(EX_WB_ctrl_out),
        .ID_EX_rd_out(ID_EX_rd),
        .ID_EX_MemRead,
        .branch_result(EX_branch_result_out),
        .old_branch(EX_old_branch_out),
        .old_predict(EX_old_predict_out),
        .old_pc(EX_old_pc_out)
    );

    logic [`DATA_WID] MEM_data1_in, MEM_data2_in;
    logic [`MEM_CTRL_WID] MEM_MEM_ctrl_in;
    logic [`WB_CTRL_WID] MEM_WB_ctrl_in;
    assign EX_MEM_RegWrite = MEM_WB_ctrl_in[1];

    EX_MEM ex_mem_inst (
        .clk(cpuclk),
        .rst,
        .ALUres_in(EX_ALU_res_out), 
        .data2_in(EX_data_out),
        .rd_in(EX_rd_out),
        .ALUres_out(MEM_data1_in),
        .data2_out(MEM_data2_in),
        .rd_out(MEM_rd_in),
        .MEM_ctrl_in(EX_MEM_ctrl_out),
        .WB_ctrl_in(EX_WB_ctrl_out),
        .MEM_ctrl_out(MEM_MEM_ctrl_in),
        .WB_ctrl_out(MEM_WB_ctrl_in)
    );

    logic [`REGS_WID] MEM_rd_out;
    logic [`DATA_WID] MEM_data1_out, MEM_data2_out;
    logic [`WB_CTRL_WID] MEM_WB_ctrl_out;
    logic [`DATA_WID] mem_addr, mem_write_data, mem_data;
    logic MemWrite, web;
    logic [`LDST_WID] ldst;

    assign MEMtoEX_data = mem_addr;

    Stage_MEM mem_instance (
        .MEM_ctrl_in(MEM_MEM_ctrl_in),
        .WB_ctrl_in(MEM_WB_ctrl_in),
        .write_addr(MEM_data1_in),
        .write_data(MEM_data2_in),
        .EX_MEM_rd(MEM_rd_in),
        .MEM_rd_out,
        .addr_out(MEM_data1_out),
        .data_out(MEM_data2_out),
        .WB_ctrl_out(MEM_WB_ctrl_out),
        .mem_addr,
        .mem_write_data,
        .MemWrite,
        .ldst,
        .mem_data
    );

    logic [`DATA_WID] WB_data1_in, WB_data2_in;
    logic [`WB_CTRL_WID] WB_WB_ctrl_in;
    logic [`DATA_WID] uart_mem_data, uart_mem_addr;
    logic [`LDST_WID] uart_LDST;
    assign MEM_WB_RegWrite = WB_WB_ctrl_in[1];
    // select uart or internal access
    assign uart_mem_addr = uart_done ? mem_addr : uart_addr;
    assign uart_mem_data = uart_done ? mem_write_data : uart_data;
    assign uart_LDST = uart_done ? ldst : 7;
    assign web = uart_done ? MemWrite : 1;

    MEM_WB mem_wb_inst (
        .clk(cpuclk),
        .rst,
        .addr_in(MEM_data1_out),
        .data_in(MEM_data2_out),
        .rd_in(MEM_rd_out),
        .addr_out(WB_data1_in),
        .data_out(WB_data2_in),
        .rd_out(MEM_WB_rd),
        .WB_ctrl_in(MEM_WB_ctrl_out),
        .WB_ctrl_out(WB_WB_ctrl_in)
    );

    Stage_WB wb_inst (
        .WB_ctrl(WB_WB_ctrl_in),
        .data(WB_data2_in),
        .ALU_res(WB_data1_in),
        .write_data(WB_data_out)
    );

    Memory memory_inst (
        .clka(memclk),
        .clkb(memclk),
        .ldst(uart_LDST),
        .addra(mem_pc),
        .addrb(uart_mem_addr),
        .write_datab(uart_mem_data),
        .web,
        .sepc,
        .dataa(mem_inst),
        .datab(mem_data),
        .switches1,
        .switches2,
        .switches3,
        .bt1,
        .bt2,
        .bt3,
        .bt4,
        .bt5,
        .led1_out,
        .led2_out,
        .led3_out
    );

    // debug use
    assign pc_t = IF_pc_in;
    assign inst_t = ID_inst_in;
    assign EX_data1_t = EX_data1_in;
    assign EX_data2_t = EX_data2_in;
    assign EX_imm_t = EX_imm_in;
    assign MEM_addr_t = MEM_data1_in;
    assign MEM_data_t = MEM_data2_in;
    assign WB_data_t = WB_data1_in;
    assign WB_mem_t = WB_data2_in;
    assign WB_data_ot = WB_data_out;
    assign sepc_t = sepc;

endmodule
