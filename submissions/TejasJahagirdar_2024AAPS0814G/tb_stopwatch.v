`timescale 1ns/1ps
module tb_stopwatch;
reg        clk;
reg        rst_n;
reg        start;
reg        stop;
reg        reset;

wire [7:0] minutes;
wire [5:0] seconds;
wire [1:0] status;

stopwatch_top dut (
    .clk     (clk),
    .rst_n   (rst_n),
    .start   (start),
    .stop    (stop),
    .reset   (reset),
    .minutes (minutes),
    .seconds (seconds),
    .status  (status)
);


initial begin
    clk = 0;
    forever #10 clk = ~clk;   // Toggle every 10 ns
end

initial begin
    rst_n  = 0;
    start = 0;
    stop  = 0;
    reset = 0;

    #25;
    rst_n = 1;  

    #20;
    start = 1;

    #20;
    start = 0;

    #100;
    stop = 1;

    #20;
    stop = 0;

    #60;
    start = 1;

    #20;
    start = 0;

    #80;
    reset = 1;

    #20;
    reset = 0;
    
    #60;
    $finish;
end

initial begin
        $display("Time(ns) | State | Minutes | Seconds");
        $monitor("%8t |   %b   |   %0d    |   %0d",
                 $time, status, minutes, seconds);
end

initial begin
        $dumpfile("stopwatch.vcd");
        $dumpvars(0, tb_stopwatch);
end

endmodule

