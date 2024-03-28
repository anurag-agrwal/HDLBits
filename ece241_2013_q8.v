module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    reg [1:0] state, next_state;
    parameter S0=0, S1=1, S2=2, S3=3;
    
    always@(posedge clk, negedge aresetn)
        begin
            if (!aresetn) state <= S0;
            else state <= next_state;
        end
    
    always@(*)
        begin
            z = 1'b0;
            case(state)
                S0: begin next_state = x ? S1 : S0; end
                S1: begin next_state = x ? S1 : S2; end
                S2: begin next_state = x ? S3 : S0; z = x ? 1'b1 : 1'b0; end
                S3: begin next_state = x ? S1 : S2; end
             endcase
        end

endmodule
