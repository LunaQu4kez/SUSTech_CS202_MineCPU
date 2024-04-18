`include "Const.svh"

module Memory (
    input                    clka, clkb, // rst,
    input  logic [`LDST_WID] ldst,
    input  logic [`DATA_WID] addra, addrb,
    input  logic [`DATA_WID] write_datab,
    input  logic             web, // port b write enable
    input  logic [`DATA_WID] sepc,
    output logic [`DATA_WID] dataa, datab,
    // IO related
    input  logic [7:0      ] switches1, switches2, switches3,
    input                    bt1, bt2, bt3, bt4, bt5,   // middle, up, down, left, right
    output logic [7:0      ] led1_out, led2_out, led3_out 
);

    reg [1:0] cnt = 2'b00;
    logic we;
    assign we = web & (cnt == 3);

    always_ff @(posedge clkb) begin : counter
        if (cnt == 3) cnt <= 0;
        else cnt <= cnt + 1;
    end

    logic [`DATA_WID] wdatab, rdatab;
    logic [`DATA_WID] datab_mem, datab_io;
    logic bool_io;
    assign bool_io = (addrb[31:16] == 16'hffff);  // 1: io, 0: mem
    assign datab = bool_io ? datab_io : datab_mem;

    logic [`DATA_WID] rdataa, edataa;
    logic bool_exc;  // exception or not
    assign bool_exc = (addra[31:16] == 16'h1c09);
    assign dataa = bool_exc ? edataa : rdataa;

    
    // IP RAM Simulation
    /*
    MemoryAnalog test_inst (
        .clka(~clka),
        .clkb(~clkb),
        .addra(addra[15:2]),
        .addrb(addrb[15:2]),
        .write_datab(bool_io ? 0 : wdatab),
        .web(we & ~bool_io),
        .dataa(rdataa),
        .datab(rdatab)
    );
    */
    
    Mem mem_inst (
        .clka(~clka),
        .clkb(~clkb),
        .addra(addra[15:2]),
        .addrb(addrb[15:2]),
        .dina(0),
        .dinb(bool_io ? 0 : wdatab),
        .douta(rdataa),
        .doutb(rdatab),
        .ena(1'b1),
        .enb(1'b1),
        .wea(1'b0),
        .web(we & ~bool_io)
    );

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

    always_comb begin : Exception_Instruction
        unique case (addra[15:0])
            16'h0000: edataa = `addi_sp_sp_m8;
            16'h0004: edataa = `sw_t0_4_sp;
            16'h0008: edataa = `sw_t1_0_sp;
            16'h000c: edataa = `addi_t1_zero_1;
            16'h0010: edataa = `lw_tp_44_gp;
            16'h0014: edataa = `lw_t0_24_gp;
            16'h0018: edataa = `beq_t0_t1_out;
            16'h001c: edataa = `beq_zero_zero_loop;
            16'h0020: edataa = `lw_a0_0_gp;
            16'h0024: edataa = `lw_t1_0_sp;
            16'h0028: edataa = `lw_t0_4_sp;
            16'h002c: edataa = `addi_sp_sp_8;
            16'h0030: edataa = `jalr_zero_tp_0;
            default:  edataa = `nop;
        endcase
    end


    // MMIO Regs
    // output
    logic [7:0] led1, led2, led3;
    assign led1_out = led1;
    assign led2_out = led2;
    assign led3_out = led3;

    always_comb begin
        unique case (addrb)
            32'hffff_ff00: begin     // switches1
                datab_io = {24'h000000, switches1};
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff04: begin     // switches2
                datab_io = {24'h000000, switches2};
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff08: begin     // switches3
                datab_io = {24'h000000, switches3};
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff0c: begin     // led1
                datab_io = 0;
                led1 = write_datab[7:0];
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff10: begin     // led2
                datab_io = 0;
                led1 = led1;
                led2 = write_datab[7:0];
                led3 = led3;
            end
            32'hffff_ff14: begin     // led3
                datab_io = 0;
                led1 = led1;
                led2 = led2;
                led3 = write_datab[7:0];
            end
            32'hffff_ff18: begin     // button1 middle
                datab_io = bt1 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff1c: begin     // button2 up
                datab_io = bt2 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff20: begin     // button3 down
                datab_io = bt3 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff24: begin     // button4 left
                datab_io = bt4 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff28: begin     // button5 right
                datab_io = bt5 ? 32'h00000001 : 32'h00000000;
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            32'hffff_ff2c: begin     // sepc
                datab_io = sepc;
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
            default: begin
                datab_io = 0;
                led1 = led1;
                led2 = led2;
                led3 = led3;
            end
        endcase
    end


endmodule
