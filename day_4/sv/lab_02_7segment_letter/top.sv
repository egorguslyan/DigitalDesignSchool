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

    assign led    = 4'hf;
    assign buzzer = 1'b0;
    assign hsync  = 1'b1;
    assign vsync  = 1'b1;
    assign rgb    = 3'b0;

    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h
    //
    //  0 means light

    typedef enum bit [7:0]
    {
        A = 8'b00010001,
        B = 8'b11000001,
        C = 8'b01100011,
        E = 8'b01100001,
        G = 8'b01000011,
        H = 8'b10010001,
        I = 8'b11110011,
        K = 8'b01010001,
        L = 8'b11100011,
        O = 8'b00000011,
        P = 8'b00110001,
        r = 8'b11110101,
        S = 8'b01001001,
        U = 8'b10000011,
        dis = {8{1'b1}}
    }
    seven_seg_encoding_e;

    // assign abcdefgh = key_sw [0] ? K : B;
    // assign digit    = key_sw [1] ? 4'b1110 : 4'b1101;

    // Exercise 1: Display the first letters
    // of your first name and last name instead.

    // assign abcdefgh = key_sw[0] ? (key_sw[1] ? G : U) : (key_sw[1] ? E : G);
    // assign digit    = key_sw[1] ? 4'b1101 : 4'b1110;

    // Exercise 2: Display letters of a 4-character word
    // using this code to display letter of AUCA as an example

    seven_seg_encoding_e letter;
    
    always_comb
      case (key_sw)
      4'b0111: letter = C;
      4'b1011: letter = H;
      4'b1101: letter = I;
      4'b1110: letter = P;
      default: letter = dis;
      endcase
      
    assign abcdefgh = letter;
    assign digit    = key_sw == 4'b1111 ? 4'b0000 : key_sw;

endmodule
