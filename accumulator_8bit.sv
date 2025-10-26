module accumulator_8bit (
  input wire       i_clk,
  input wire       ni_rst,
  input wire [7:0] i_a,
  output reg      o_carry,
  output reg      o_ovf
);
//========================DECLARATION============================================================================
  wire       ovf, carry;
  reg        a_ld, a_clr;
  reg        s_ld, s_clr;
  reg  [7:0] o_a, o_s;
  reg  [7:0] o_sum;
  reg         current_state, next_state;

  parameter s0 = 0, s1 = 1;
//========================CONTROLLER============================================================================
  always_ff @( posedge i_clk or negedge ni_rst ) begin : reg_state
    if(~ni_rst) begin
      current_state <= s0;
    end else begin
    current_state <= next_state;
    end
  end

  always_comb begin : state_transition
    case (current_state)
        s0:    next_state = s1;
        s1: begin
            if(~o_ovf) begin
              next_state = s1;
            end else begin
              next_state = s0;
            end
        end
        default: next_state = s1;
    endcase
  end

  always_comb begin : datapath_output
    case (current_state)
        s0 : begin
            s_ld     = 1'b0;
            s_clr    = 1'b1;
            a_ld     = 1'b1;
            a_clr    = 1'b1;
        end
        s1: begin
            s_ld     = 1'b1;
            s_clr    = 1'b0;
            a_ld     = 1'b1;
            a_clr    = 1'b0;
        end
        default: begin
            s_ld     = 1'b0;
            s_clr    = 1'b1;
            a_ld     = 1'b0;
            a_clr    = 1'b1;
        end
    endcase
  end
//========================DATAPATH============================================================================
  adder_8bit adder_8bit (
                          .i_a(o_a),
                          .i_b(o_s),
                          .i_cin(1'b0),
                          .o_sum(o_sum),
                          .o_ovf(ovf),
                          .o_carry(carry)
                        );
  always_ff @( posedge i_clk or negedge ni_rst ) begin : a_register
    if( ~ni_rst) begin
        o_a <= 8'b0;
        o_s <= 8'b0;
    end else if (a_clr) begin
        o_a <= 8'b0;
    end else if (s_clr) begin
        o_s <= 8'b0;
    end if (a_ld) begin
        o_a <= i_a;
    end if (s_ld) begin
        o_s <= o_sum;
    end
    o_carry <= carry;
    o_ovf   <= ovf;
  end
endmodule
