// Asynchronous reset here is needed for the FPGA board we use

module top
(
    input        clk,
    input        reset_n,
    
    input  [3:0] key_sw,
    output [3:0] led,

    output [7:0] abcdefgh,
    output [3:0] digit,

    output       buzzer,

    output       hsync,
    output       vsync,
    output [2:0] rgb
);

    wire reset = ~ reset_n;

    // assign abcdefgh  = 8'hff;
    // assign digit     = 4'hf;
    assign buzzer    = 1'b0;
    assign hsync     = 1'b1;
    assign vsync     = 1'b1;
    assign rgb       = 3'b0;
    
    //------------------------------------------------------------------------

    logic [31:0] cnt;
    
    always_ff @ (posedge clk or posedge reset)
      if (reset)
        cnt <= 32'b0;
      else
        cnt <= cnt + 32'b1;
        
    wire enable = (cnt [22:0] == 23'b0);

    //------------------------------------------------------------------------

    wire button_on = ~ key_sw [0];
    wire button_off = ~ key_sw [1];

    logic [3:0] shift_reg;
    
    // always_ff @ (posedge clk or posedge reset)
    //   if (reset)
    //     shift_reg <= 4'b0;
    //   else if (enable)
    //     shift_reg <= { button_on, shift_reg [3:1] };

    assign led = ~ shift_reg;

    // Exercise 1: Make the light move in the opposite direction.

    // always_ff @ (posedge clk or posedge reset)
    //   if (reset)
    //     shift_reg <= 4'b0;
    //   else if (enable)
    //     shift_reg <= { shift_reg [2:0], button_on };

    // Exercise 2: Make the light moving in a loop.
    // Use another key to reset the moving lights back to no lights.

    always_ff @ (posedge clk or posedge reset)
      if (reset)
        shift_reg <= 4'b0;
      else if (enable)
        shift_reg <= { (button_on | shift_reg[0]) & ~ button_off, shift_reg [3:1] };

    // Exercise 3: Display the state of the shift register
    // on a seven-segment display, moving the light in a circle.

    assign digit = 4'b1110;
    assign abcdefgh = {2'b11, ~shift_reg[3:1], 1'b1, ~shift_reg[0], 1'b1};

endmodule
