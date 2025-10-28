`timescale 1ns/1ps
module comparator_8bit_TB();
  //// stimulus input ////
  logic unsigned [7:0] A, B;
  //// expected output ////
  logic unsigned [7:0] Min, Max;
  //// unit under test ////
  comparator_8bit uut (
    .A ( A),
    .B ( B),
    .Min ( Min ),
    .Max ( Max )
  );
  int seed = 314159;
  initial begin 
    $dumpfile ("comparator_8bit_TB.vcd");
    $dumpvars (0, comparator_8bit_TB);
    A = 8'd31;
    B = 8'd230;
    #10;
    A = 8'd134;
    B = 8'd127;
    #10;
    A = 8'd136;
    B = 8'd136;
    #10;
    for ( int i = 0; i < 7 ; i++ ) begin
      A = $random(seed);
      B = $random(seed);
      #10;
    end
  end
  initial begin 
    $monitor("A= %d, B= %d, Min= %d, Max= %d",A, B, Min, Max);
  end
endmodule   
