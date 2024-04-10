module CPU_Sim ();

    logic cpuclk, memclk, rst_n, uart_finish;
    logic [7:0] switches;
    logic [31:0] led;
    logic [31:0] pc_t, inst_t;
    logic [31:0] EX_data1_t, EX_data2_t, EX_imm_t, MEM_addr_t, MEM_data_t, WB_data_t, WB_mem_t, WB_data_ot;
    
    CPU cpu_inst (
        .cpuclk,
        .memclk,
        .rst_n,
        .uart_finish,
        .switches,
        .led_out(led),
        .pc_t,
        .inst_t,
        .EX_data1_t, 
        .EX_data2_t, 
        .EX_imm_t, 
        .MEM_addr_t, 
        .MEM_data_t, 
        .WB_data_t, 
        .WB_mem_t, 
        .WB_data_ot
    );

    initial begin
        rst_n = 1;
        cpuclk = 0;
        memclk = 1;
        uart_finish = 1;
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
        #800 $finish;
    join
    
endmodule