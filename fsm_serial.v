module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    reg [3:0] state, next_state;
    parameter IDLE=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8, START=9, DONE=10, WAIT=11;
    
    always@(posedge clk)
        begin
            if(reset) state <= IDLE;
            else state <= next_state;
        end
    
    always@(*)
        begin
            case(state)
                IDLE: next_state = in ? IDLE : START;
                START: next_state = S1;
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S4;
                S4: next_state = S5;
                S5: next_state = S6;
                S6: next_state = S7;
                S7: next_state = S8;
                S8: next_state = in ? DONE : WAIT;
                WAIT: next_state = in ? IDLE : WAIT;
                DONE: next_state = in ? IDLE : START;
            endcase
        end
    
    assign done = (state == DONE);

endmodule
