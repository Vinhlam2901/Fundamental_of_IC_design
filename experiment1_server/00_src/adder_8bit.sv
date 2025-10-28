module adder_8bit (
    input  wire [7:0] i_a,
    input  wire [7:0] i_b,
    input  wire       i_cin,
    output wire [7:0] o_sum,
    output wire       o_ovf,
    output wire       o_carry
);
  wire [6:0] c;
  full_adder f0 (
    .X_i(i_a[0]),
    .B_i(i_b[0]),
    .C_i(i_cin),
    .S_o(o_sum[0]),
    .C_o(c[0])
);
  full_adder f1 (
    .X_i(i_a[1]),
    .B_i(i_b[1]),
    .C_i(c[0]),
    .S_o(o_sum[1]),
    .C_o(c[1])
);
  full_adder f2 (
    .X_i(i_a[2]),
    .B_i(i_b[2]),
    .C_i(c[1]),
    .S_o(o_sum[2]),
    .C_o(c[2])
);
  full_adder f3 (
    .X_i(i_a[3]),
    .B_i(i_b[3]),
    .C_i(c[2]),
    .S_o(o_sum[3]),
    .C_o(c[3])
);
  full_adder f4 (
    .X_i(i_a[4]),
    .B_i(i_b[4]),
    .C_i(c[3]),
    .S_o(o_sum[4]),
    .C_o(c[4])
);
  full_adder f5 (
    .X_i(i_a[5]),
    .B_i(i_b[5]),
    .C_i(c[4]),
    .S_o(o_sum[5]),
    .C_o(c[5])
);
  full_adder f6 (
    .X_i(i_a[6]),
    .B_i(i_b[6]),
    .C_i(c[5]),
    .S_o(o_sum[6]),
    .C_o(c[6])
);
  full_adder f7 (
    .X_i(i_a[7]),
    .B_i(i_b[7]),
    .C_i(c[6]),
    .S_o(o_sum[7]),
    .C_o(o_carry)
);
  assign o_ovf = o_carry ^ c[6];
endmodule
module full_adder (
  input logic X_i, B_i, C_i,
  output logic S_o, C_o
);
  assign S_o = X_i ^ B_i ^ C_i;
  assign C_o = ( X_i & B_i ) | ( ( X_i ^ B_i ) & C_i );
endmodule 
