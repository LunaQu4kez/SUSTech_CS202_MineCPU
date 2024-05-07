`include "Const.svh"

module ICache #(
    parameter CACHE_WID = 6
)(
    input  logic             clk, rst,
    // cpu interface
    input  logic [`DATA_WID] addr,
    input  logic             predict_fail,
    output logic [`DATA_WID] inst,
    output logic             icache_stall,
    // mem interface
    input  logic [`DATA_WID] mem_inst,
    output logic [`DATA_WID] mem_pc
);

    // format: valid[38] | tag[37:32] | data[31:0]
    reg  [46-CACHE_WID:0] cache [0: (1 << CACHE_WID) - 1];
    reg  [1:0] read_state = 0;
    wire [CACHE_WID-1:0] offset = addr[CACHE_WID+1:2];
    wire [13-CACHE_WID:0] tag = addr[15:CACHE_WID+2];
    assign mem_pc = addr;
    assign inst = read_state == 2 ? mem_inst : cache[offset][`DATA_WID];
    assign icache_stall = !predict_fail && (!cache[offset][46-CACHE_WID] || cache[offset][45-CACHE_WID:32] != tag) && (read_state != 3);

    initial begin
        // read_state = 0;
        for (int i = 0; i < (1 << CACHE_WID); i++) begin
            cache[i] = 0;
        end        
    end

    // read from memory
    always_ff @(negedge clk) begin
        if (rst || !icache_stall) begin
            read_state <= 0;
        end else begin
            read_state <= read_state + 1;
        end
    end

    // write to cache
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < (1 << CACHE_WID); i++) begin
                cache[i] <= 0;
            end
        end else begin
            cache[offset] <= (read_state == 2) ? {1'b1, tag, mem_inst} : cache[offset];
        end
    end
    
endmodule
