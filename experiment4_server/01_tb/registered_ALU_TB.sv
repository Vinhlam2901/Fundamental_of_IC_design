module registered_ALU_TB();
  //========================DECLARATION============================================================================
  // stimulus inputs //
  logic              i_clk;
  logic              reset;
  logic signed [7:0] i_a;
  logic        [1:0] i_sel;
  // expected outputs //
  logic signed [7:0] o_result;
  logic              o_carry;
  logic              o_ovf;

  //========================MODULE INSTANTIATION==================================================================
  registered_ALU uut (
    .i_clk(i_clk),
    .i_reset(reset),
    .i_a(i_a),
    .i_sel ( i_sel ),
    .o_carry(o_carry),
    .o_ovf(o_ovf),
    .o_result ( o_result )
  );

  //========================CLOCK GENERATION======================================================================
  // (Clock) 50MHz
  always begin
    #10 i_clk = ~i_clk;  // T clock 20ns -> f 50MHz
  end

  //========================TEST SEQUENCE=========================================================================  
  initial begin
    $dumpfile("registered_ALU_TB.vcd");
    $dumpvars(0, registered_ALU_TB);
//////////////////////    
////// add test ////// i_sel = 00
//////////////////////
    // cycle 0 // reset //
    i_clk = 0;
    reset = 0;       
    i_a = 8'd17;
    i_sel = 2'b00;
    #20;
    // cycle 1 //               
    reset = 1;      
    i_a = 8'd17; // 17 + 0 = 17 //
    #20;
    // cycle 2 //          
    i_a = 8'd75; // 75 + 17 = 92 /
    #20; 
    // cycle 3 // 
    i_a = 8'b11000001; // -63 // -63 + 92 = 29//
    #20;
    // cycle 4 
    i_a = 8'b11011100; // -36 // -36 + 29 = -7 //
    #20;
    // cycle 5 //
    i_a = 8'd0;  
    #20;
    // cycle 6 //
    i_a = 8'd0; 
    #10;
    reset = 0;
    #10;
    // cycle 7 // start positive overflow check //
    reset  = 1'b1;
    i_a = 8'd93; 
    #20;   
    // cycle 8 // 93 + 0 = 93 //
    i_a = 8'd93; 
    #20;
    // cycle 9 // 93 + 93 = overflow //
    i_a = 8'd93; 
    #20;
    // cycle 10 //
    i_a = 8'd93; 
    #20; 
    // cycle 11 // start negative overflow check //
    i_a = 8'b11011011; // -37 //
    #10;
    reset = 1'b0;
    #10;
    // cycle 12-13-14-15-16 // add -37 by itself until overfolw //
     reset = 1'b1;
     i_a = 8'b11011011; // -37 //
     #100;   
///////////////////////////
////// subtract test ////// i_sel = 01
///////////////////////////
    // cycle 0 // reset //
    reset = 0;       
    i_a = 8'b11011100; // -36 //
    i_sel = 2'b01;
    #20;
    // cycle 1 // test the subtractor //               
    reset = 1;        
    i_a = 8'b11011100; // -36 // -36 - 0 = -36 //
    #20;
    // cycle 2 //       
    i_a = 8'b11000001; // -63 // -63 - (-36) = -27 // 
    #20; 
    // cycle 3 // 
    i_a = 8'b11110110; // -10 // -10 -(-27) = 17 //
    #20;
    // cycle 4 // 
    i_a = 8'd120;             // 120 - 17 = 103 //
    #20;
    // cycle 5 // 
    i_a = 8'd57;              // 57 - 103 = -46 //
    #20;
    // cycle 6 //
    i_a = 8'b11010010; // -46 // -46 -(-46) = 0 //
    #20;
    // cycle 7 //
    i_a = 8'd0; // -46 //
    #20;
    // cycle 8 // start positive overflow check // 
    // first, assign the negative value for the output //
    i_a = 8'b11000001; // -63 // 
    #10; 
    reset  = 1'b0;
    #10;
    // cycle 9 //
    reset = 1'b1;
    i_a = 8'b11000001; // -63 // -63 + 0 = -63 //
    #20;   
    // cycle 10 // 
    // the next step, assign the positive value for the input //
    // check the overflow flag for "positive value - negative value" //
    i_a = 8'd75;       // -63 - 75 = overfolw //
    #20;
    // cycle 11 //
    i_a = 8'd75; 
    #20;
    // cycle 12 //
    i_a = 8'd75;
    #20; 
    // cycle 13 // start negative overflow check // 
    // first, assign the positive value for the output //
    i_a = 8'd0;  
    #10;
    reset = 1'b0;
    #10;
    // cycle 14 //
    reset = 1'b1;    
    i_a = 8'd115;    // 115 + 0 = 115 //
    #20;
    // cycle 15-16-17-18//
    // the next step, assign the negative value for the input //
    // check the overflow flag for "negative value - positive value" // 
     reset = 1'b1;
     i_a = 8'b11100101; //-27// sub o_result by -27 until overflow //
     #60;
///////////////////////
//// min - max ////////
///////////////////////
     // cycle 0 // 
     reset = 0;
     i_a = 8'd123;
     i_sel = 2'b10; // max //
     #20;
     // cycle 1 //
     reset = 1;
     i_a = 8'd27;
     #20;
     // cycle 2 //
     i_a = 8'd67;
     #20;
     // cycle 3 //
     i_a = 8'd36;
     #20;
     // cycle 4 //
     i_a = 8'd123;
     #20;
     // cycle 5 //
     i_a = 8'd91;
     #20;
     // cycle 6 //
     i_a = 8'd63;
     i_sel = 2'b11; // min //
     #20;
     // cycle 7 //
     i_a = 8'd74;
     #20;
     // cycle 8 //
     i_a = 8'd17;
     #50;
    $finish;
  end

  //========================MONITOR OUTPUTS=======================================================================
  initial begin
    $monitor("%t: i_a = %d, o_a =%d, result = %d, o_reslut = %d, o_ovf = %b , o_carry = %b , reset = %b",$time, i_a, uut.a_reg, uut.result_alu, o_result, o_ovf, o_carry, reset);
  end

endmodule




