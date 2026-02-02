module minutes_counter (
    input  wire       clk,
    input  wire       rst_n,        // global reset
    input  wire       enable,
    input  wire       reset,        // stopwatch reset
    input  wire       sec_rollover,
    output reg  [7:0] minutes
);

always @(posedge clk) begin
    if (!rst_n) begin
        minutes <= 8'd0;
    end
    else if (enable && sec_rollover) begin
        if (minutes == 8'd99)
            minutes <= 8'd0;
        else
            minutes <= minutes + 1'b1;
    end
    else if (reset) begin
        minutes <= 8'd0;
    end
end

endmodule
