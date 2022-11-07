`include "config.vh"

`ifdef USE_STRUCTURAL_IMPLEMENTATION

module counter #(
    parameter w = 4
) (
    input            clk,
    input            reset,
    input            en,
    output [w - 1:0] cnt
);

  wire [w - 1:0] q;
  wire [w - 1:0] d = cnt + 1;

  register #(w) i_reg (
      clk,
      reset,
      en,
      d,
      q
  );

  assign cnt = q;

endmodule

module random_counter #(
    parameter w = 4
) (
    input            clk,
    input            reset,
    input            en,
    output [w - 1:0] cnt
);

  wire [w - 1:0] q;
  wire [w - 1:0] d = {q[w-2:0], (q[w-2] ^ q[w-3])};

  register #(w) i_reg (
      clk,
      reset,
      en,
      d,
      q
  );

  assign cnt = q;

endmodule

`else

module counter #(
    parameter w = 1
) (
    input                clk,
    input                reset,
    input                en,
    output reg [w - 1:0] cnt
);

  always @(posedge clk or posedge reset)
    if (reset) cnt <= {w{1'b0}};
    else if (en) cnt <= cnt + 'b1;

endmodule

module random_counter #(
    parameter w = 1,
    parameter seed = 'b1000
) (
    input                clk,
    input                reset,
    input                en,
    output reg [w - 1:0] cnt
);

  always @(posedge clk or posedge reset)
    if (reset) cnt <= seed;
    else if (en) cnt <= {cnt[w-2:0], (cnt[w-1] ^ cnt[w-2])};

endmodule

`endif
