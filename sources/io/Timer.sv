`include "Const.sv"

module Timer (
    input         clk, rst,
    output [31:0] time
);

    reg [31:0] timer = 0;
    reg [15:0] cnt = 0;
    assign time = timer;

    always_ff @(posedge clk) begin
        if (rst) begin
            timer <= 0;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
            if (cnt == 100_000) begin
                timer <= timer + 1;
                cnt <= 0;
            end
        end
    end
    
endmodule
