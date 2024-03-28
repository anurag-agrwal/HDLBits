module top_module (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    reg [2:0] state, next_state;
    parameter IDLE=0, S1=1, S2=2, S3=3, S4=4, FINAL=5;
    
    always@(posedge clk)
        begin
            if(reset) state <= IDLE;
            else state <= next_state;
        end
    
    always@(*)
        begin
            shift_ena = 1'b0;
            case(state)
                IDLE: begin next_state = S1; shift_ena = 1'b1; end
                S1: begin next_state = S2; shift_ena = 1'b1; end
                S2: begin next_state = S3; shift_ena = 1'b1; end
                S3: begin next_state = S4; shift_ena = 1'b1; end
                S4: next_state = FINAL;
                FINAL: next_state = FINAL;
            endcase
        end
    
 /*   always@(*)
        begin
            case(next_state)
                IDLE: shift_ena = 1'b0;
                S1: shift_ena = 1'b1;
                S2: shift_ena = 1'b1;
                S3: shift_ena = 1'b1;
                S4: shift_ena = 1'b1;
                FINAL: shift_ena = 1'b0;
            endcase
        end
*/
endmodule
