`include "Const.svh"

module Stage_IF (
    input  logic [`DATA_WID]        pc_now,
    output logic [`DATA_WID]        pc_out,
    output logic [`DATA_WID]        pc_next,
    output logic [`DATA_WID]        inst,
    // interact with Memory
    output logic [`DATA_WID]        mem_pc,
    input  logic [`DATA_WID]        mem_inst
);

    assign pc_out = pc_now;
    assign pc_next = pc_now + 4;
    assign inst = mem_inst;
    assign mem_pc = pc_now;


endmodule