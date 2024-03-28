module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
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
    
    // New: Datapath to latch input bits.
    
    reg [7:0] data = 8'b0;
    
    always@(posedge clk)
        begin
            if(reset) data <= 8'b0;
            else if (next_state == S1) data[0] <= in;
            else if (next_state == S2) data[1] <= in;
            else if (next_state == S3) data[2] <= in;
            else if (next_state == S4) data[3] <= in;
            else if (next_state == S5) data[4] <= in;
            else if (next_state == S6) data[5] <= in;
            else if (next_state == S7) data[6] <= in;
            else if (next_state == S8) data[7] <= in;
	end
	
	always@(posedge clk)
        begin
            case(next_state)
                S1: data[0] = in;
                S2: data[1] = in;
                S3: data[2] = in;
                S4: data[3] = in;
                S5: data[4] = in;
                S6: data[5] = in;
                S7: data[6] = in;
                S8: data[7] = in;
            endcase
        end
    
    assign out_byte = (state == DONE) ? data : 8'b0;

endmodule
