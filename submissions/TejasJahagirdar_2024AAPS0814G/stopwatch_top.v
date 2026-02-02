module stopwatch_top (
    input  wire        clk,        // System clock
    input  wire        rst_n,      // Active-low global reset
    input  wire        start,      // Start / Resume button
    input  wire        stop,       // Pause button
    input  wire        reset,      // Logical reset
    output wire [7:0]  minutes,    // Minutes output (0–99)
    output wire [5:0]  seconds,    // Seconds output (0–59)
    output wire [1:0]  status      // FSM state (observable)
);

wire count_en;
wire sec_rollover;

control_fsm u_fsm(
    .clk      (clk),
        .rst_n    (rst_n),
        .start    (start),
        .stop     (stop),
        .reset    (reset),
        .count_en (count_en),
        .status   (status)
);
seconds_counter u_seconds (
        .clk      (clk),
        .rst_n    (rst_n),
        .enable   (count_en),
        .reset    (reset),
        .seconds  (seconds),
        .rollover (sec_rollover)
);
minutes_counter u_minutes (
        .clk          (clk),
        .rst_n        (rst_n),
        .enable       (count_en),
        .reset        (reset),
        .sec_rollover (sec_rollover),
        .minutes      (minutes)
);
endmodule
