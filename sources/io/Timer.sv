module Timer (
    input               clk, rst,
    output logic [31:0] timer
);

    reg [16:0] cnt = 0;
    always_ff @(posedge clk) begin
        if (rst) begin
            timer <= 0;
            cnt <= 0;
        end else begin
            if (cnt == 100_000) begin
                timer <= timer + 1;
                cnt <= 0;
            end else begin
                timer <= timer;
                cnt <= cnt + 1;
            end
        end
    end
    
endmodule
