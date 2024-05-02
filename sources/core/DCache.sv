`include "Const.svh"

module DCache (
    input  logic             clk, rst,
    // cpu interface
    input  logic [`DATA_WID] addr,
    input  logic [`LDST_WID] ldst,
    output logic [`DATA_WID] data,
    output logic             dcache_stall,
    // mem interface
    input  logic [`DATA_WID] mem_data,
    output logic [`DATA_WID] mem_addr
);

    // format: valid[53] | dirty[52] | tag[51:32] | data[31:0]
    reg  [`CACHE_WID] cache [0: (1 << 10) - 1];
    reg  [1:0 ] read_state, write_state;
    wire [9:0] offset;
    wire [19:0] tag;
    assign mem_addr = addr;
    assign offset = addr[11:2];
    assign tag = addr[31:12];

    assign inst = read_state == 2 ? mem_inst : cache[offset][31:0];
    assign dcache_stall = (!cache[offset][53] || cache[offset][51:32] != tag) && (read_state != 2);

    initial begin
        read_state = 0;
        for (int i = 0; i < (1 << 12); i++) begin
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

       always_comb begin
        unique case (ldst)
            `LW_OP: begin
                datab_mem = rdatab;
                wdatab = 0;
            end
            `LH_OP: begin
                if (addrb[1]) begin
                    datab_mem = {rdatab[31] ? 16'hffff : 16'h0000, rdatab[31:16]};
                end
                else begin
                    datab_mem = {rdatab[15] ? 16'hffff : 16'h0000, rdatab[15:0]};
                end
                wdatab = 0;
            end
            `LHU_OP: begin
                datab_mem = {16'h0000, addrb[1] ? rdatab[31:16] : rdatab[15:0]};
                wdatab = 0;
            end
            `LBU_OP: begin
                datab_mem = {24'h000000, addrb[1] ? (addrb[0] ? rdatab[31:24] : rdatab[23:16]) : (addrb[0] ? rdatab[15:8] : rdatab[7:0])};
                wdatab = 0;
            end
            `LB_OP: begin
                unique case (addrb[1:0])
                    2'b00: datab_mem = {rdatab[7] ? 24'hffffff : 24'h000000, rdatab[7:0]};
                    2'b01: datab_mem = {rdatab[15] ? 24'hffffff : 24'h000000, rdatab[15:8]};
                    2'b10: datab_mem = {rdatab[23] ? 24'hffffff : 24'h000000, rdatab[23:16]};
                    2'b11: datab_mem = {rdatab[31] ? 24'hffffff : 24'h000000, rdatab[31:24]};
                endcase
                wdatab = 0;
            end
            `SW_OP: begin
                wdatab = write_datab;
                datab_mem = rdatab;
            end
            `SH_OP: begin
                wdatab = addrb[1] ? {write_datab[15:0], rdatab[15:0]} : {rdatab[31:16], write_datab[15:0]};
                datab_mem = rdatab;
            end
            `SB_OP: begin
                unique case (addrb[1:0])
                    2'b00: wdatab = {rdatab[31:8], write_datab[7:0]};
                    2'b01: wdatab = {rdatab[31:16], write_datab[7:0], rdatab[7:0]}; 
                    2'b10: wdatab = {rdatab[31:24], write_datab[7:0], rdatab[15:0]}; 
                    2'b11: wdatab = {write_datab[7:0], rdatab[23:0]}; 
                endcase
                datab_mem = rdatab;
            end
        endcase
    end
    
endmodule
