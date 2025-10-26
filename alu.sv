module alu (
    input  wire       i_clk,
    input  wire       i_reset,
    input  wire [7:0] i_a,
    input  wire [7:0] i_b,
    input  wire [1:0] i_sel,
    output reg  [7:0] o_result
);
  reg [7:0] a_reg, b_reg;
  wire is_add, is_sub, i_max, is_min;
  wire add_sub_sel;
  wire [7:0] min, max;
  wire [7:0] result;
  wire [7:0] result_o;

  always_ff @( posedge i_clk or negedge i_reset ) begin : input_register
    if(~i_reset) begin
        a_reg <= 8'b0;
        b_reg <= 8'b0;
    end else begin
        a_reg <= i_a;
        b_reg <= i_b;
    end
  end

  assign is_add = ~i_sel[0] & ~i_sel[1];
  assign is_sub = ~i_sel[0] &  i_sel[1];
  assign is_max =  i_sel[0] & ~i_sel[1];
  assign is_min =  i_sel[0] &  i_sel[1];

  comparator_8bit cp8 (
                        .A   (a_reg),
                        .B   (b_reg),
                        .Min (min),
                        .Max (max)
                      );

  assign add_sub_sel = (is_add) ? 1'b0 : 1'b1;

  add_subtract add_sub (
                        .a_i      (a_reg),
                        .b_i      (b_reg),
                        .add_sub  (add_sub_sel),
                        .result_o (result_o),
                        .o_carry  (o_carry),
                        .o_ovf    (o_ovf)
                      );

  assign result = (is_add) ? result_o :
                  (is_sub) ? result_o :
                  (is_min) ? min      :
                  (is_max) ? max      :
                  8'b0;

  always_ff @( posedge i_clk or negedge i_reset  ) begin : output_register
    if(~i_reset) begin
        o_result <= 8'b0;
    end else begin
        o_result <= result;
    end
  end

endmodule

