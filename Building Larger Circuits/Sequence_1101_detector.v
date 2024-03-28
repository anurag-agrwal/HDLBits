module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
    
    reg [2:0] state, next_state;
    parameter IDLE=0, S1=1, S2=2, S3=3, S4=4;
    
    always@(posedge clk)
        begin
            if (reset) state <= IDLE;
            else state <= next_state;
        end
    
    always@(*)
        begin
            case(state)
                IDLE: next_state = data ? S1 : IDLE;
                S1: next_state = data ? S2 : IDLE;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S4 : IDLE;
                S4: next_state = S4;
            endcase
        end
    
    assign start_shifting = (state == S4);

endmodule
