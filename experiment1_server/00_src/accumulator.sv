module accumulator_8bit (
  input logic       i_clk,
  input logic       ni_rst,
  input logic [7:0] i_a,
  output logic [7:0] o_s,
  output logic      o_carry,
  output logic      o_ovf
);
//========================DECLARATION============================================================================
  logic       ovf, carry;
  logic signed  [7:0] o_a;
  logic signed  [7:0] i_s;

//========================DATAPATH============================================================================
  adder_8bit adder_8bit (
                          .i_a(o_a),
                          .i_b(o_s),
                          .i_cin(1'b0),
                          .o_sum(i_s),
                          .o_ovf(ovf),
                          .o_carry(carry)
                        );
  always_ff @( posedge i_clk or negedge ni_rst ) begin : a_register
    if( ~ni_rst) begin
        o_a <= 8'd0;
    end else begin
        o_a <= i_a;
    end 
  end
  
  always_ff @( posedge i_clk or negedge ni_rst ) begin : s_register
    if( ~ni_rst) begin
        o_s <= 8'd0;
    end else begin
        o_s <= i_s;
    end 
  end
  
  always_ff @( posedge i_clk or negedge ni_rst ) begin : carry_ff
    if( ~ni_rst) begin
        o_carry <= 1'b0;
    end else begin
        o_carry <= carry;
    end 
  end
  always_ff @( posedge i_clk or negedge ni_rst ) begin : ovf_ff
    if( ~ni_rst) begin
        o_ovf <= 1'b0;
    end else begin
        o_ovf <= ovf;
    end 
  end
endmodule
