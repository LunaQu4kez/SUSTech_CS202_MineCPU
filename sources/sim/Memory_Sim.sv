module Memory_Sim ();
    logic cpuclk;
    logic clka, clkb;
    logic [2:0] ldst;
    logic [31:0] addra, addrb;
    logic [31:0] write_datab;
    logic [0:0] web;            // port b write enable
    logic [31:0] dataa, datab;
    logic [7:0] switches;
    logic [31:0] led;

    Memory mem_test_inst (
        .clka,
        .clkb,
        .ldst,
        .addra,
        .addrb,
        .write_datab,
        .web,
        .dataa,
        .datab,
        .switches,
        .led_out(led)
    );

    initial begin
        clka = 0;
        addra = 0;
        cpuclk = 0;

        clkb = 0;
        ldst = 0;
        addrb = 0;
        write_datab = 0;
        web = 0;
        switches = 0;
        forever begin
            #5 clkb = ~clkb;
        end
    end
    
    initial fork
        #5 cpuclk = ~cpuclk;
        #25 cpuclk = ~cpuclk;
        #45 cpuclk = ~cpuclk;
        #65 cpuclk = ~cpuclk;
        #85 cpuclk = ~cpuclk;
        #105 cpuclk = ~cpuclk;
        #125 cpuclk = ~cpuclk;
        #145 cpuclk = ~cpuclk;
        #165 cpuclk = ~cpuclk;
        #185 cpuclk = ~cpuclk;
        #205 cpuclk = ~cpuclk;
        #225 cpuclk = ~cpuclk;
        #245 cpuclk = ~cpuclk;
        #265 cpuclk = ~cpuclk;
        #285 cpuclk = ~cpuclk;
        #305 cpuclk = ~cpuclk;
        #325 cpuclk = ~cpuclk;
        #345 cpuclk = ~cpuclk;
        #365 cpuclk = ~cpuclk;
    join

    initial fork
        #5 ldst = 7; // store word
        #5 addrb = 100;
        #5 write_datab = 32'h123456f8;
        #5 web = 1;

        #45 ldst = 7; // store word
        #45 addrb = 32'hffff_ff04;
        #45 write_datab = 32'h0000_0005;
        #45 web = 1;

        /*
        #45 ldst = 2; // load word
        #45 addrb = 100;
        #45 write_datab = 32'h000fff00;
        #45 web = 0;
        */

        #85 ldst = 1; // load half
        #85 addrb = 102;
        #85 write_datab = 32'h000fff00;
        #85 web = 0;

        #125 ldst = 0; // load byte
        #125 addrb = 100;
        #125 write_datab = 32'h000fff00;
        #125 web = 0;

        #165 ldst = 0; // load byte
        #165 addrb = 100;
        #165 write_datab = 32'h000fff00;
        #165 web = 0;

        #205 ldst = 5; // store byte
        #205 addrb = 101;
        #205 write_datab = 32'hffffffab;
        #205 web = 1;

        #245 ldst = 2; // load word
        #245 addrb = 100;
        #245 write_datab = 32'h000fff00;
        #245 web = 0;

        #285 ldst = 6; // store half
        #285 addrb = 102;
        #285 write_datab = 32'hffffde98;
        #285 web = 1;

        #325 ldst = 2; // load word
        #325 addrb = 100;
        #325 write_datab = 32'h000fff00;
        #325 web = 0;

        #365 $finish;
    join


endmodule