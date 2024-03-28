module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    reg [3:0] state, next_state;
    parameter IDLE=0, B1=1, B2=2, B3=3, B4=4, B5=5, S1=6, FLAG=7, ERR=8, DISC=9;
    
    always@(posedge clk)
        begin
            if(reset) state <= IDLE;
            else state <= next_state;
        end
    
    always@(*)
        begin
            case(state)
                IDLE: next_state = in ? B1 : IDLE;
                B1: next_state = in ? B2 : IDLE;
                B2: next_state = in ? B3 : IDLE;
                B3: next_state = in ? B4 : IDLE;
                B4: next_state = in ? B5 : IDLE;
                B5: next_state = in ? S1 : DISC;
                DISC: next_state = in ? B1 : IDLE;
                S1: next_state = in ? ERR : FLAG;
                FLAG: next_state = in ? B1 : IDLE;
                ERR: next_state = in ? ERR : IDLE;
            endcase
        end
    
    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err = (state == ERR);

endmodule
