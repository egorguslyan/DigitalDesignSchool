`include "config.vh"

module moore_fsm
(
    input  clk,
    input  reset,
    input  en,
    input  a,
    output y
);
    
    parameter [0:5] code = 6'b101101;

    reg [2:0] state;
    wire [2:0] next_state;

    // State register

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= 0;
        else if (en)
            state <= next_state;

    // Next state logic

    assign next_state = code[state] == a ? (state >= 5 ? 1 : state + 1) : 0;

    // Output logic based on current state

    assign y = (state == 5);

endmodule
