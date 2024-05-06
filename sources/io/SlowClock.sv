module SlowClock (
    input clk,
    output clk0
);

    reg [31:0] cnt;
    reg t = 0;
    assign clk0 = t;

    always @(posedge clk) begin
        if (cnt == 50000000) begin
            cnt <= 0;
        end
        else begin
           cnt <= cnt + 1'b1; 
        end
    end

    always @(posedge clk) begin
        if (cnt == 50000000) begin
            t <= ~t;
        end 
    end
    
endmodule