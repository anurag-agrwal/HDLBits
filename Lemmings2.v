module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    reg [1:0] state, next_state;
    parameter LEFT=0, RIGHT=1, FALL_LEFT=2, FALL_RIGHT=3;
    
    always@(posedge clk, posedge areset)
        begin
            if(areset) state <= LEFT;
            else state <= next_state;
        end
    
    always@(*)
        begin
            case(state)
                LEFT: next_state = ground ? (bump_left ? RIGHT : LEFT) : FALL_LEFT;
                RIGHT: next_state = ground ? (bump_right ? LEFT : RIGHT) : FALL_RIGHT;
                FALL_LEFT: next_state = ground ? LEFT : FALL_LEFT;
                FALL_RIGHT: next_state = ground ? RIGHT : FALL_RIGHT;
            endcase
        end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = ((state == FALL_LEFT) | (state == FALL_RIGHT));
    
endmodule
