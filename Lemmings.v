module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    // parameter LEFT=0, RIGHT=1, ...
    reg state, next_state;
    parameter LEFT=0, RIGHT=1;

    always @(*) begin
        // State transition logic
        case(state)
            LEFT : begin next_state = bump_left ? RIGHT : LEFT; walk_left = 1'b1; walk_right = 1'b0; end
            RIGHT: begin next_state = bump_right? LEFT  : RIGHT; walk_left = 1'b0; walk_right = 1'b1; end
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) state <= LEFT;
        else state <= next_state;
    end

    // Output logic
  //  assign walk_left = (state == LEFT);
  //  assign walk_right = (state == RIGHT);

endmodule
