module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //
    
    reg [1:0] state, next_state;
    parameter byte1=0, byte2=1, byte3=2, DONE=3;

    // FSM from fsm_ps2
    always@(*)
        begin
            case(state)
                byte1: next_state = in[3] ? byte2 : byte1;
                byte2: next_state = byte3;
                byte3: next_state = DONE;
                DONE:  next_state = in[3] ? byte2 : byte1;
            endcase
        end

    // State flip-flops (sequential)
    always@(posedge clk, posedge reset)
        begin
            if(reset) state <= byte1;
            else state <= next_state;
        end
 
    // Output logic
    assign done = (state == DONE);

    reg [23:0] data = 24'b0;
    
    // New: Datapath to store incoming bytes.
    always@(posedge clk, posedge reset)
        begin
            if(reset) data <= 24'b0;
            else if(state == byte1) data[23:16] = in;
            else if(state == byte2) data[15:8] = in;
            else if(state == byte3) data[7:0] = in;
            else if(state == DONE) data[23:16] = in;
        end
    
    assign out_bytes = (state == DONE) ? data : 24'b0;

endmodule
