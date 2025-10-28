module registered_ALU (
    input  wire       i_clk,
    input  wire       i_reset,
    input  wire [7:0] i_a,
    input  wire [1:0] i_sel,
    output reg  [7:0] o_result,
    output logic      o_carry, o_ovf
);
  reg [7:0] a_reg;
  wire is_add, is_sub, is_max, is_min;
  wire add_sub_sel;
  wire [7:0] min, max;
  wire [7:0] result_alu;
  wire [7:0] result_add_subtract;
  logic ovf,carry;
///////////////
//// reg a ////
///////////////
  always_ff @( posedge i_clk or negedge i_reset ) begin : input_register
    if(~i_reset) begin
        a_reg <= 8'b0;
    end else begin
        a_reg <= i_a;
    end
  end
//////////////
//// ALU /////
//////////////
  assign is_add = ~i_sel[1] & ~i_sel[0];
  assign is_sub = ~i_sel[1] &  i_sel[0];
  assign is_max =  i_sel[1] & ~i_sel[0];
  assign is_min =  i_sel[1] &  i_sel[0];

  comparator_8bit cp8 (
                        .A   (a_reg),
                        .B   (o_result),
                        .Min (min),
                        .Max (max)
                      );

  assign add_sub_sel = (is_add) ? 1'b0 : 1'b1;

  add_subtract add_sub (
                        .a_i      (a_reg),
                        .b_i      (o_result),
                        .add_sub  (add_sub_sel),
                        .result_o (result_add_subtract),
                        .o_carry  (carry),
                        .o_ovf    (ovf)
                      );

  assign result_alu = (is_add) ? result_add_subtract :
                      (is_sub) ? result_add_subtract :
                      (is_min) ? min      :
                      (is_max) ? max      :
                      8'b0;
///////////////////
//// reg output ///
///////////////////
  always_ff @( posedge i_clk or negedge i_reset  ) begin : output_register
    if(~i_reset) begin
        o_result <= 8'b0;
        o_ovf    <= 1'b0;
        o_carry  <= 1'b0;
    end else begin
        o_result <= result_alu;
        o_ovf    <= ovf & ( is_add | is_sub );
        o_carry  <= carry & ( is_add | is_sub );
    end
  end

endmodule
