`define BPS_CNT 868
`define MAX_DATA 32'h7fff

module UART (
    input               clk, rst, rx,
    // ports to memory
    output logic [31:0] data_out,
    output logic [31:0] addr_out,
    output logic        done
);

    reg rxd_t, rxd_t1, rxd_t2, rx_done;
    reg [7:0] rx_data;
    reg [15:0] idle_cnt;
    assign done = (addr_out >= `MAX_DATA) || (idle_cnt == 16'hf);

    Queue queue (
        .clk(clk),
        .rst(rst),
        .data_in(rx_data),
        .ready_in(rx_done),
        .data_out,
        .addr_out
    );

    always_ff @(posedge clk) begin
        if (rst | en_state) begin
            idle_cnt <= 16'h0;
        end else begin
            idle_cnt <= idle_cnt + 1'b1;
        end
    end
    
    always_ff @(posedge clk) begin
        if (rst) begin
            rxd_t <= 1'b1;
            rxd_t1 <= 1'b1;
            rxd_t2 <= 1'b1;
        end else begin
            rxd_t <= rx;
            rxd_t1 <= rxd_t;
            rxd_t2 <= rxd_t1;
        end
    end

    reg en_state;
    wire nedge;
    assign nedge = !rxd_t1 & rxd_t2;
    
    always_ff @(posedge clk) begin
        if (rst) en_state <= 1'b0;
        else if (nedge) en_state <= 1'b1;
        else if (rx_done) en_state <= 1'b0;
        else en_state <= en_state;
    end

    parameter bit_tim = `BPS_CNT;
    reg [9:0] baud_cnt;

    always_ff @(posedge clk) begin
        if (rst) baud_cnt <= 10'b0;
        else if (en_state) begin
            if(baud_cnt == bit_tim - 1'b1) baud_cnt <= 10'b0;
            else baud_cnt <= baud_cnt + 1'b1;
        end else baud_cnt <= 10'b0;
    end
    
    reg [3:0] bit_cnt;
    always_ff @(posedge clk) begin
        if (rst) bit_cnt <= 4'd0;
        else if (en_state) begin
            if(bit_cnt == 4'd0) bit_cnt <= bit_cnt + 1'b1;
            else if(baud_cnt == bit_tim - 1'b1) bit_cnt <= bit_cnt + 1'b1;
            else bit_cnt <= bit_cnt;
        end else bit_cnt <= 4'b0;
    end

    //rx_data
    always_ff @(posedge clk) begin
        if (rst) rx_data <= 8'd0;    
        else if (en_state) begin
            case (bit_cnt)
                4'd2: rx_data[0] <= rxd_t2;
                4'd3: rx_data[1] <= rxd_t2;
                4'd4: rx_data[2] <= rxd_t2;
                4'd5: rx_data[3] <= rxd_t2;
                4'd6: rx_data[4] <= rxd_t2;
                4'd7: rx_data[5] <= rxd_t2;
                4'd8: rx_data[6] <= rxd_t2;
                4'd9: rx_data[7] <= rxd_t2;
             default: rx_data <= rx_data;
            endcase
        end else begin
            rx_data <= rx_data;
        end
    end

    //rx_done
    always_ff @(posedge clk) begin
        if (rst) begin
            rx_done <= 1'b0;
        end else if (en_state) begin
            if(bit_cnt == 0) rx_done <= 1'b0;
            else if(bit_cnt == 10 && baud_cnt == bit_tim - 1) rx_done <= 1'b1;
            else if(rx_done == 1'b1) rx_done <= 1'b0;
            else rx_done <= rx_done;
        end else if(rx_done == 1'b1) rx_done <= 1'b0;
        else rx_done <= rx_done;
    end
        
endmodule
