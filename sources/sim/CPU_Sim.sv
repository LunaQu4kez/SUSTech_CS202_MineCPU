module CPU_Sim ();

    logic cpuclk, memclk, rst;
    logic [7:0] switches;
    logic [31:0] led;
    logic [31:0] pc;
    logic [31:0] inst;
    logic [31:0] EX_data1_t, EX_data2_t, EX_imm_t, MEM_addr_t, MEM_data_t, WB_data_t, WB_mem_t, WB_data_ot;
    logic [1:0] fwB_t;
    
    CPU cpu_inst (
        .cpuclk,
        .memclk,
        .rst,
        .switches,
        .led_out(led),
        .pc,
        .inst,
        .EX_data1_t, 
        .EX_data2_t, 
        .EX_imm_t, 
        .MEM_addr_t, 
        .MEM_data_t, 
        .WB_data_t, 
        .WB_mem_t, 
        .WB_data_ot,
        .fwB_t
    );

    initial begin
        rst = 0;
        cpuclk = 0;
        memclk = 1;
        switches = 0;
        forever begin
            #5 memclk = ~memclk;
        end
    end

    initial fork
        forever begin
            #20 cpuclk = ~cpuclk;
        end
    join

    initial fork
        #500 $finish;
    join
    
endmodule