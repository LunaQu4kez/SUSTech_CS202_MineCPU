`include "Const.svh"

module ICache (
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

    // format: valid[41] | dirty[40] | tag[39:32] | data[31:0]
    // here dirty is regarded as use bit
    reg  [`CACHE_WID] cache [0: (1 << 10) - 1];
    reg  [1:0] read_state;
    wire [9:0] offset;
    wire [7:0] tag;
    assign mem_pc = addr;
    assign offset = addr[11:2];
    assign tag = addr[19:12];
    assign inst = read_state == 2 ? mem_inst : cache[offset][31:0];
    assign icache_stall = !predict_fail && (!cache[offset][41] || cache[offset][39:32] != tag) && (read_state != 2);

    initial begin
        read_state = 0;
        for (int i = 0; i < (1 << 10); i++) begin
            cache[i] = 0;
        end        
    end

    // read from memory
    always_ff @(negedge clk) begin
        if (rst || !icache_stall) begin
            read_state <= 0;
        end else begin
            read_state <= read_state == 2 ? 0 : read_state + 1;
        end
    end

    // write to cache
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < (1 << 10); i++) begin
                cache[i] <= 0;
            end
        end else begin
            cache[offset] <= (read_state == 2) ? {2'b10, tag, mem_inst} : cache[offset];
        end
    end
    
endmodule
