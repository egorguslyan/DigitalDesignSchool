module top #(
    parameter debounce_depth             = 8,
              num_strobe_width0          = 23,
              num_strobe_width1          = num_strobe_width0 + 1,
              num_strobe_width2          = num_strobe_width0 + 2,
              num_strobe_width3          = num_strobe_width0 + 3,
              seven_segment_strobe_width = 10
) (
    input clk,
    input reset_n,

    input  [3:0] key_sw,
    output [3:0] led,

    output [7:0] abcdefgh,
    output [3:0] digit,

    output buzzer,

    output       hsync,
    output       vsync,
    output [2:0] rgb
);

  localparam code = 16'hbf4c;
  localparam lose = 16'h105e;
  localparam win = 16'h0bed;

  assign buzzer = 1'b0;
  assign hsync  = 1'b1;
  assign vsync  = 1'b1;
  assign rgb    = 3'b0;
  assign led    = 4'b0;

  //------------------------------------------------------------------------

  wire reset = ~reset_n;

  //------------------------------------------------------------------------

  wire [3:0] key_db;

  sync_and_debounce #(
      .w(4),
      .depth(debounce_depth)
  ) i_sync_and_debounce_key (
      clk,
      reset,
      ~key_sw,
      key_db
  );

  //------------------------------------------------------------------------

  reg  [3:0] prev_key;
  wire [3:0] key_fronts;

  always @(posedge clk) begin
    prev_key <= key_db;
  end

  assign key_fronts = ~prev_key & key_db;

  //------------------------------------------------------------------------

  wire [3:0] num_strobe;

  wire [3:0] seg_strobe;

  strobe_gen #(
      .w(num_strobe_width0)
  ) i_num_strobe0 (
      clk,
      reset,
      num_strobe[0]
  );
  strobe_gen #(
      .w(num_strobe_width1)
  ) i_num_strobe1 (
      clk,
      reset,
      num_strobe[1]
  );
  strobe_gen #(
      .w(num_strobe_width2)
  ) i_num_strobe2 (
      clk,
      reset,
      num_strobe[2]
  );
  strobe_gen #(
      .w(num_strobe_width3)
  ) i_num_strobe3 (
      clk,
      reset,
      num_strobe[3]
  );

  reg  [3:0] key_db_lock;
  wire [3:0] key_counter;

  assign key_counter =    key_db_lock[0] ? 4'b1111 :
                            key_db_lock[1] ? 4'b0001 :
                            key_db_lock[2] ? 4'b0010 :
                            key_db_lock[3] ? 4'b0100 :
                                             4'b1000 ;

  always @(posedge clk or posedge reset) begin
    if (reset) key_db_lock <= 4'b0;
    else if (key_counter == 'b1111 && key_fronts) key_db_lock <= 4'b0;
    else begin
      key_db_lock <= key_db_lock | (key_db & key_counter);
    end
  end

  assign seg_strobe = num_strobe & ~key_db_lock;

  //------------------------------------------------------------------------

  wire [3:0] num_count0;
  wire [3:0] num_count1;
  wire [3:0] num_count2;
  wire [3:0] num_count3;

  random_counter #(4) i_num_counter0 (
      .clk  (clk),
      .reset(reset),
      .en   (seg_strobe[0]),
      .cnt  (num_count0)
  );

  random_counter #(4) i_num_counter1 (
      .clk  (clk),
      .reset(reset),
      .en   (seg_strobe[1]),
      .cnt  (num_count1)
  );

  random_counter #(4) i_num_counter2 (
      .clk  (clk),
      .reset(reset),
      .en   (seg_strobe[2]),
      .cnt  (num_count2)
  );

  random_counter #(4) i_num_counter3 (
      .clk  (clk),
      .reset(reset),
      .en   (seg_strobe[3]),
      .cnt  (num_count3)
  );

  //------------------------------------------------------------------------

  wire [15:0] result_number = {num_count3, num_count2, num_count1, num_count0};

  wire [15:0] number_to_display = key_counter != 'b1111 ? result_number :
                                    result_number == code ?           win :
                                                                     lose ;

  //------------------------------------------------------------------------

  wire seven_segment_strobe;

  strobe_gen #(
      .w(seven_segment_strobe_width)
  ) i_seven_segment_strobe (
      clk,
      reset,
      seven_segment_strobe
  );

  seven_segment #(
      .w(16)
  ) i_seven_segment (
      .clk    (clk),
      .reset  (reset),
      .en     (seven_segment_strobe),
      .num    (number_to_display),
      .dots   (key_db),
      .abcdefg(abcdefgh[7:1]),
      .dot    (abcdefgh[0]),
      .anodes (digit)
  );

endmodule
