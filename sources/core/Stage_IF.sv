`include "Const.svh"

module Stage_IF (
    input  logic [`DATA_WID]        new_pc,
    input  logic                    PC_Write,
    output logic [`DATA_WID]        pc_out,
    output logic [`DATA_WID]        inst,
    // interact with Memory
    input  logic [`DATA_WID]        mem_inst
    output logic [`DATA_WID]        mem_pc,
);

    assign inst = mem_inst;
    assign mem_pc = pc_now;


endmodule