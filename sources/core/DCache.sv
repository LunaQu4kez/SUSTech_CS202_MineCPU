`include "Const.svh"

module DCache (
    input  logic             clk, rst,
    // cpu interface
    input  logic [`DATA_WID] addr,
    input  logic [`DATA_WID] write_data,
    input  logic [`LDST_WID] ldst,
    input  logic             MemWrite,
    output logic [`DATA_WID] data_out,
    output logic             dcache_stall,
    // mem interface
    input  logic [`DATA_WID] mem_data,
    output logic [`DATA_WID] mem_addr,
    output logic [`DATA_WID] mem_write_data,
    output logic             mem_web
);

    // format: valid[53] | dirty[52] | tag[51:32] | data[31:0]
    reg  [`CACHE_WID] cache [0: (1 << 10) - 1];
    // state of memory
    reg  [1:0 ] read_state, write_state;
    reg  [`DATA_WID] wb_data, wb_addr;
    reg  [`DATA_WID] rdata_out, wdata_out;
    wire [`DATA_WID] rdata_in;
    wire [9:0] offset;
    wire [19:0] tag;
    wire bool_io;
    assign bool_io = (addr[31:16] == 16'hffff);  // 1: io, 0: mem
    assign mem_addr = addr;
    assign offset = addr[11:2];
    assign tag = addr[31:12];
    assign rdata_in = cache[offset][31:0];
    assign data_out = (read_state == 2 || bool_io) ? mem_data : rdata_out;
    assign dcache_stall = (!bool_io) && (!cache[offset][53] || cache[offset][51:32] != tag) && (read_state != 2);

    initial begin
        read_state = 0;
        for (int i = 0; i < (1 << 10); i++) begin
            cache[i] = 0;
        end        
    end

    // read from memory
    always_ff @(negedge clk) begin
        if (rst || !dcache_stall) begin
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
            cache[offset] <= (read_state == 2) ? {2'b10, tag, mem_data} : cache[offset];
        end
    end

    always_comb begin
        unique case (ldst)
            `LW_OP: begin
                rdata_out = rdata_in;
                wdata_out = 0;
            end
            `LH_OP: begin
                if (addr[1]) begin
                    rdata_out = {rdata_in[31] ? 16'hffff : 16'h0000, rdata_in[31:16]};
                end
                else begin
                    rdata_out = {rdata_in[15] ? 16'hffff : 16'h0000, rdata_in[15:0]};
                end
                wdata_out = 0;
            end
            `LHU_OP: begin
                rdata_out = {16'h0000, addr[1] ? rdata_in[31:16] : rdata_in[15:0]};
                wdata_out = 0;
            end
            `LBU_OP: begin
                rdata_out = {24'h000000, addr[1] ? (addr[0] ? rdata_in[31:24] : rdata_in[23:16]) : (addr[0] ? rdata_in[15:8] : rdata_in[7:0])};
                wdata_out = 0;
            end
            `LB_OP: begin
                unique case (addr[1:0])
                    2'b00: rdata_out = {rdata_in[7] ? 24'hffffff : 24'h000000, rdata_in[7:0]};
                    2'b01: rdata_out = {rdata_in[15] ? 24'hffffff : 24'h000000, rdata_in[15:8]};
                    2'b10: rdata_out = {rdata_in[23] ? 24'hffffff : 24'h000000, rdata_in[23:16]};
                    2'b11: rdata_out = {rdata_in[31] ? 24'hffffff : 24'h000000, rdata_in[31:24]};
                endcase
                wdata_out = 0;
            end
            `SW_OP: begin
                wdata_out = write_data;
                rdata_out = rdata_in;
            end
            `SH_OP: begin
                wdata_out = addr[1] ? {write_data[15:0], rdata_in[15:0]} : {rdata_in[31:16], write_data[15:0]};
                rdata_out = rdata_in;
            end
            `SB_OP: begin
                unique case (addr[1:0])
                    2'b00: wdata_out = {rdata_in[31:8], write_data[7:0]};
                    2'b01: wdata_out = {rdata_in[31:16], write_data[7:0], rdata_in[7:0]}; 
                    2'b10: wdata_out = {rdata_in[31:24], write_data[7:0], rdata_in[15:0]}; 
                    2'b11: wdata_out = {write_data[7:0], rdata_in[23:0]}; 
                endcase
                rdata_out = rdata_in;
            end
        endcase
    end
    
endmodule
