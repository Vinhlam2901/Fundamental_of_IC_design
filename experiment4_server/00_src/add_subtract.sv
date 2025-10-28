module add_subtract (
    input  wire [7:0]  a_i,
    input  wire [7:0]  b_i,
    input              add_sub,     // 0: C?ng, 1: Tr?
    output wire [7:0]  result_o,
    output             o_carry,
    output             o_ovf
);
  wire [6:0] c;
  wire [7:0] b_mod_i;

  assign b_mod_i      = b_i ^ {8{add_sub}}; // n?u b_i là [3:0] và add_sub là 1 bit

  full_adder f0 ( .X_i(a_i[0]), .B_i(b_mod_i[0]), .C_i(add_sub), .S_o(result_o[0]), .C_o(c[0])    );
  full_adder f1 ( .X_i(a_i[1]), .B_i(b_mod_i[1]), .C_i(c[0]),    .S_o(result_o[1]), .C_o(c[1])    );
  full_adder f2 ( .X_i(a_i[2]), .B_i(b_mod_i[2]), .C_i(c[1]),    .S_o(result_o[2]), .C_o(c[2])    );
  full_adder f3 ( .X_i(a_i[3]), .B_i(b_mod_i[3]), .C_i(c[2]),.    S_o(result_o[3]), .C_o(c[3])    );
  full_adder f4 ( .X_i(a_i[4]), .B_i(b_mod_i[4]), .C_i(c[3]),.    S_o(result_o[4]), .C_o(c[4])    );
  full_adder f5 ( .X_i(a_i[5]), .B_i(b_mod_i[5]), .C_i(c[4]),.    S_o(result_o[5]), .C_o(c[5])    );
  full_adder f6 ( .X_i(a_i[6]), .B_i(b_mod_i[6]), .C_i(c[5]),.    S_o(result_o[6]), .C_o(c[6])    );
  full_adder f7 ( .X_i(a_i[7]), .B_i(b_mod_i[7]), .C_i(c[6]),.    S_o(result_o[7]), .C_o(o_carry) );

  assign o_ovf = o_carry ^ c[6];
endmodule
/////////////
//// FA /////
/////////////
module full_adder (
  input logic X_i, B_i, C_i,
  output logic S_o, C_o
);
  assign S_o = X_i ^ B_i ^ C_i;
  assign C_o = ( X_i & B_i ) | ( ( X_i ^ B_i ) & C_i );
endmodule 
