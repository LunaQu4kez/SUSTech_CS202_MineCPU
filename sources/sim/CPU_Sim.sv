module CPU_Sim ();

    logic cpuclk, memclk, rst_n, uart_finish;
    logic [7:0] switches1;
    logic [7:0] led1;
    logic [31:0] pc_t, inst_t;
    logic [31:0] EX_data1_t, EX_data2_t, EX_imm_t, MEM_addr_t, MEM_data_t, WB_data_t, WB_mem_t, WB_data_ot, sepc_t;
    logic [7:0] switches2, switches3;
    logic [7:0] led2, led3;
    logic bt1, bt2, bt3, bt4, bt5;
    
    CPU cpu_inst (
        .cpuclk,
        .memclk,
        .rst_n,
        .uart_finish,
        .switches1,
        .switches2,
        .switches3,
        .bt1,
        .bt2,
        .bt3,
        .bt4,
        .bt5,
        .led1_out(led1),
        .led2_out(led2),
        .led3_out(led3),
        .pc_t,
        .inst_t,
        .EX_data1_t, 
        .EX_data2_t, 
        .EX_imm_t, 
        .MEM_addr_t, 
        .MEM_data_t, 
        .WB_data_t, 
        .WB_mem_t, 
        .WB_data_ot,
        .sepc_t
    );

    initial begin
        rst_n = 1;
        cpuclk = 0;
        memclk = 1;
        uart_finish = 1;
        switches1 = 0;
        bt1 = 0;
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
        #200 switches1 = 8'h07;
        #253 bt1 = 1;
        #600 bt1 = 0;
    join

    initial fork
        #1000 $finish;
    join
    
endmodule