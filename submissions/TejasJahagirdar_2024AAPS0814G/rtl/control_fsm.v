module control_fsm (
    input  wire       clk,
    input  wire       rst_n,     
    input  wire       start,     
    input  wire       stop,      
    input  wire       reset,     
    output reg        count_en,  
    output reg [1:0]  status     // 00=IDLE, 01=RUNNING, 10=PAUSED
);
localparam IDLE=2'b00;
localparam RUNNING=2'b01;
localparam PAUSED=2'b10;

reg [1:0] next_state;

always @(posedge clk) begin
    if(!rst_n)
        status <= IDLE;
    else
        status <= next_state;    
end

always @(*) begin
    next_state = status;

    case(status)
        IDLE: begin
            if (reset)
                next_state = IDLE;
            else if (start)
                next_state = RUNNING;
        end

        RUNNING: begin
            if (reset)
                next_state = IDLE;
            else if (stop)
                next_state = PAUSED;
        end

        PAUSED: begin
            if (reset)
                next_state = IDLE;
            else if (start)
                next_state = RUNNING;
        end

        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(*) begin
    if (status == RUNNING)
         count_en = 1'b1;
    else
        count_en = 1'b0;
end

endmodule
            
