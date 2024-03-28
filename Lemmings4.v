module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    reg [2:0] state, next_state;
    parameter LEFT=0, RIGHT=1, FALL_LEFT=2, FALL_RIGHT=3, DIG_LEFT=4, DIG_RIGHT=5, SPLA=6, aaah_end=7;
    reg [4:0] count = 5'b0;
    
    always@(posedge clk, posedge areset)
        begin
            if(areset) state <= LEFT;
            else state <= next_state; 
        end
    
    always@(posedge clk, posedge areset)
        begin
            if (areset) count <= 5'b0;
            else if (next_state == FALL_LEFT || next_state == FALL_RIGHT) count <= count + 1'b1;
            else count <= 5'b0;
        end
    
    always@(*)
        begin
            case(state)
                LEFT: next_state = ground ? (dig ? DIG_LEFT : (bump_left ? RIGHT : LEFT)) : FALL_LEFT;
                RIGHT : next_state = ground ? (dig ? DIG_RIGHT : (bump_right ? LEFT : RIGHT)) : FALL_RIGHT;
                DIG_RIGHT : next_state = ground ? DIG_RIGHT : FALL_RIGHT;
                DIG_LEFT : next_state = ground ? DIG_LEFT : FALL_LEFT;
                FALL_RIGHT: next_state = ground ? RIGHT : ((count == 20) ? SPLA : FALL_RIGHT);
                FALL_LEFT: next_state = ground ? LEFT : ((count == 20) ? SPLA : FALL_LEFT);
                SPLA: next_state = ground ? aaah_end : SPLA;
                aaah_end : next_state = aaah_end;
            endcase
        end
    
    assign walk_left = (state == LEFT) && ~(state == aaah_end);
    assign walk_right = (state == RIGHT) && ~(state == aaah_end);
    assign digging = ((state == DIG_LEFT) || (state == DIG_RIGHT)) && ~(state == aaah_end);
    assign aaah = ((state == FALL_LEFT) || (state == FALL_RIGHT) || (state == SPLA)) & ~(state == aaah_end);
        
endmodule
