module CPU_Clk (
    input clk,
    output clk0
);

    reg cnt = 0;
    reg t = 0;
    assign clk0 = t;

    always @(posedge clk) begin
        if (cnt == 1) begin
            cnt <= 0;
        end
        else begin
           cnt <= cnt + 1'b1; 
        end
    end

    always @(posedge clk) begin
        if (cnt == 1) begin
            t <= ~t;
        end 
    end
    
endmodule