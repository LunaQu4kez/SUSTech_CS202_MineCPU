`include "Const.svh"

module ICache #(
    parameter CACHE_WID = 6,
    parameter PREFE_SIZ = 100
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
    // states
    reg  [1:0] read_state = 0;
    // prefetch
    wire prefetch_done;
    assign prefetch_done = (prefetch_addr == PREFE_SIZ);
    reg [15:0] prefetch_addr;
    // indexing cache
    wire uncached;
    assign uncached = addr[31:16] == 16'h1c09;
    wire [CACHE_WID-1:0] offset;
    assign offset = addr[CACHE_WID+1:2];
    wire [13-CACHE_WID:0] tag;
    assign tag = addr[15:CACHE_WID+2];
    assign mem_pc = prefetch_done ? addr : {18'b0, prefetch_addr[15:2]};
    assign inst = (read_state == 2 || uncached) ? mem_inst : cache[offset][`DATA_WID];
    assign icache_stall = !prefetch_done || !uncached && !predict_fail && (!cache[offset][46-CACHE_WID] || cache[offset][45-CACHE_WID:32] != tag) && (read_state != 3);

    always_ff @(negedge clk) begin : blockName
        if (rst) begin
            prefetch_addr <= 16'h0;
        end else if (prefetch_done) begin
            prefetch_addr <= prefetch_addr;
        end else begin
            prefetch_addr <= prefetch_addr + 1;
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
        if (!prefetch_done) begin
            cache[prefetch_addr[CACHE_WID+3:4]] <= (prefetch_addr[1:0] == 2) ? {3'b100, prefetch_addr[15:CACHE_WID+4], mem_inst} : cache[prefetch_addr[CACHE_WID+3:4]];
        end else begin
            cache[offset] <= (read_state == 2) ? {1'b1, tag, mem_inst} : cache[offset];
        end
    end
    
endmodule
