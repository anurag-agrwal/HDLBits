module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    
    reg [3:0] state, next_state;
    parameter IDLE=0, S1=1, S2=2, S3=3, S4=4;
    parameter B1=5, B2=6, B3=7, COUNT=8, DONE=9;
    
    always@(posedge clk)
        begin
            if (reset) state <= IDLE;
            else state <= next_state;
        end
    
    always@(*)
        begin
            shift_ena = 1'b0; counting = 1'b0; done = 1'b0;
            case(state)
                IDLE: next_state = data ? S1 : IDLE;
                S1: next_state = data ? S2 : IDLE;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S4 : IDLE;
                S4: begin next_state = B1; shift_ena = 1'b1; end
                B1: begin next_state = B2; shift_ena = 1'b1; end
                B2: begin next_state = B3; shift_ena = 1'b1; end
                B3: begin next_state = COUNT; shift_ena = 1'b1; end
                COUNT: begin next_state = done_counting ? DONE : COUNT; counting = 1'b1; end
                DONE: begin next_state = ack ? IDLE : DONE; done = 1'b1; end
            endcase
        end

endmodule
