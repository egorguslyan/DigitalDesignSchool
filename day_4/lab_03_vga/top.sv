module top
(
    input              clk,
    input              reset_n,

    input        [3:0] key_sw,
    output       [3:0] led,

    output       [7:0] abcdefgh,
    output       [3:0] digit,

    output             buzzer,

    output             hsync,
    output             vsync,
    output logic [2:0] rgb
);

    localparam X_WIDTH = 10,
               Y_WIDTH = 10,
               CLK_MHZ = 50;

    //------------------------------------------------------------------------

    assign led       = key_sw;
    assign abcdefgh  = 8'hff;
    assign digit     = 4'hf;
    assign buzzer    = 1'b0;

    //------------------------------------------------------------------------

    wire display_on;

    wire [X_WIDTH - 1:0] x;
    wire [Y_WIDTH - 1:0] y;
 
    vga
    # (
        .HPOS_WIDTH ( X_WIDTH      ),
        .VPOS_WIDTH ( Y_WIDTH      ),
        
        .CLK_MHZ    ( CLK_MHZ      )
    )
    i_vga
    (
        .clk        (   clk        ), 
        .reset      ( ~ reset_n    ),
        .hsync      (   hsync      ),
        .vsync      (   vsync      ),
        .display_on (   display_on ),
        .hpos       (   x          ),
        .vpos       (   y          )
    );

    //------------------------------------------------------------------------

    typedef enum bit [2:0]
    {
      black  = 3'b000,
      blue   = 3'b001,
      green  = 3'b010,
      cyan   = 3'b011,
      red    = 3'b100,
      purple = 3'b101,
      yellow = 3'b110,
      white  = 3'b111
    }
    rgb_t;

    always_comb
    begin
      if (~ display_on)
        rgb = black;
      // Circle
      else if (key_sw == 4'b1111 & (x - 600) ** 2 + (y - 200) ** 2 < 70 ** 2)
        rgb = white;
      else if (x ** 2 + y ** 2 < 100 ** 2)
        rgb = red;
      // Triangle
      else if (y > 200 & y < 400 & x > (500 - y) & x > (500 + y))
        rgb = green;
      // Rectangle
      else if (x > 200 & y > 200 & x < 300 & y < 400) 
        rgb = yellow;
      // Square
      else if (x > 100 & y > 100 & x < 300 & y < 300) 
        rgb = blue;
      // Else
      else
        rgb = black;
    end

endmodule
