module tb_accumulator_8bit;
  //========================DECLARATION============================================================================
  reg       i_clk;
  reg       reset;
  reg  signed [7:0] i_a;
  wire      o_carry;
  wire      o_ovf;

  //========================MODULE INSTANTIATION==================================================================
  accumulator_8bit uut (
    .i_clk(i_clk),
    .ni_rst(reset),
    .i_a(i_a),
    .o_carry(o_carry),
    .o_ovf(o_ovf)
  );

  //========================CLOCK GENERATION======================================================================
  // Tạo đồng hồ (Clock) 50MHz
  always begin
    #10 i_clk = ~i_clk;  // Chu kỳ clock 20ns -> Tần số 50MHz
  end

  //========================TEST SEQUENCE=========================================================================  
  initial begin
    $dumpfile("tb_accumulator_8bit.vcd");
    $dumpvars(0, tb_accumulator_8bit);
    $dumpvars(0, tb_accumulator_8bit.i_clk, tb_accumulator_8bit.reset,tb_accumulator_8bit.i_a, tb_accumulator_8bit.o_carry, tb_accumulator_8bit.o_ovf);

    i_clk = 1;
    reset = 0;          // Gửi tín hiệu reset
    i_a = 8'b1;
    #20;                // Chờ một vài chu kỳ để hệ thống ổn định

    reset = 1;          // Gửi tín hiệu reset
    i_a = 8'b00000001;
    #20;
    reset = 1;          // Tắt tín hiệu reset

    // Test 1: Cộng 80 với 80 (không có tràn số)
    i_a = 8'b01010000;  // i_a = 80
    #20; // Đợi một chu kỳ để xem kết quả
    #20;
    // Kết quả mong đợi: o_carry = 0, o_ovf = 0 (không tràn số)
   // Test 2: Cộng 100 với 100 (có tràn số)
    i_a = 8'b01100100;  // i_a = 100
    #20; // Đợi một chu kỳ để xem kết quả
    // Kết quả mong đợi: o_carry = 0, o_ovf = 1

    // >>> RESET NGAY TẠI ĐÂY <<<
    reset = 0;   // Kích reset ngay lập tức
    #5;          // Reset ngắn (không đợi tới cạnh clock nếu là async)
    reset = 1;   // Nhả reset
    #10;         // Một chút thời gian để ổn định trước khi test tiếp

    // Test 3: Cộng -50 với -50 (tràn số âm)
    i_a = 8'b11001110;  // i_a = -50
    #20; // Đợi một chu kỳ để xem kết quả

    // Test 4: Cộng 127 với 127 (có tràn số dương)
    i_a = 8'b01111111;  // i_a = 127
    #20; // Đợi một chu kỳ để xem kết quả
    // Kết quả mong đợi: o_carry = 0, o_ovf = 1 (tràn số dương)

    // Kết thúc mô phỏng
    $finish;
  end

  //========================MONITOR OUTPUTS=======================================================================
  initial begin
    $monitor("%t: i_a = %d, o_carry = %b, o_ovf = %h, o_s = %d, o_a = %d o_sum = %d, a_ld = %b, s_ld = %b, a_clr = %b, s_clr = %b", $time, i_a,  o_carry, o_ovf, uut.o_s, uut.o_a, uut.o_sum, uut.a_ld, uut.s_ld, uut.a_clr, uut.s_clr);
  end

endmodule
