module add_subtract_itself (
  input  wire       i_clk,
  input  wire       ni_rst,
  input  wire       add_sub,
  input  reg [7:0]  i_a,
  output reg        o_carry,
  output reg        o_ovf
);
//========================DECLARATION============================================================================
  wire       ovf, carry;
  reg  [7:0] o_a, o_s;
  reg  [7:0] o_result;
//========================DATAPATH============================================================================

  always_ff @( posedge i_clk or negedge ni_rst ) begin : input_state
    if(~ni_rst) begin
        o_a <= 8'b0;
    end else begin
        o_a <= i_a;
    end
end

always_ff @( posedge i_clk or negedge ni_rst ) begin : output_state
    if(~ni_rst) begin
        o_s     <= 8'b0;
        o_carry <= 1'b0;
        o_ovf   <= 1'b0;
    end else begin
        o_s     <= o_result;
        o_carry <= carry;
        o_ovf   <= ovf;
    end
end
 add_subtract adder_subtract (
                             .a_i(o_a),
                             .b_i(o_s),
                             .add_sub(add_sub),
                             .result_o(o_result),
                             .o_carry(carry),
                             .o_ovf(ovf)
                             );
endmodule
