module adder_tb;

  // Khai báo tín hiệu đầu vào và đầu ra cho mô-đun adder_8bit
  reg [7:0] i_a;    // Số thứ nhất (8 bit)
  reg [7:0] i_b;    // Số thứ hai (8 bit)
  reg i_cin;         // Carry-in
  wire [7:0] o_sum; // Tổng (8 bit)
  wire o_ovf;        // Overflow (tràn số)
  wire o_carry;      // Carry-out

  // Khởi tạo mô-đun adder_8bit
  adder_8bit uut (
    .i_a(i_a),
    .i_b(i_b),
    .i_cin(i_cin),
    .o_sum(o_sum),
    .o_ovf(o_ovf),
    .o_carry(o_carry)
  );

  // Khởi tạo tín hiệu trong testbench
  initial begin
    // Khởi tạo tín hiệu
    i_a = 8'b00000000;  // Ban đầu là 0
    i_b = 8'b00000000;  // Ban đầu là 0
    i_cin = 0;          // Carry-in là 0

    // Mô phỏng các trường hợp khác nhau

    // Test case 1: Cộng hai số dương không có overflow
    #10 i_a = 8'b01010000;  // 5
        i_b = 8'b01010000;  // 3
        i_cin = 0;          // Không có carry-in
    #10;  // Chờ 10 đơn vị thời gian để mô-đun hoạt động

    // Test case 2: Cộng hai số âm, có overflow
    #10 i_a = 8'b10000000;  // -128 (số âm)
        i_b = 8'b10000000;  // -128 (số âm)
        i_cin = 0;          // Không có carry-in
    #10;  // Chờ 10 đơn vị thời gian

    // Test case 3: Cộng hai số dương có overflow
    #10 i_a = 8'b01111111;  // 127 (số dương lớn nhất)
        i_b = 8'b00000001;  // 1
        i_cin = 0;          // Không có carry-in
    #10;  // Chờ 10 đơn vị thời gian

    // Test case 4: Cộng với carry-in
    #10 i_a = 8'b01010101;  // 85
        i_b = 8'b00101010;  // 42
        i_cin = 1;          // Carry-in là 1
    #10;  // Chờ 10 đơn vị thời gian

    // Test case 5: Cộng hai số âm, không có overflow
    #10 i_a = 8'b11111000;  // -8
        i_b = 8'b11111000;  // -8
        i_cin = 0;          // Không có carry-in
    #10;  // Chờ 10 đơn vị thời gian

    // Test case 6: Cộng số dương và số âm
    #10 i_a = 8'b00000100;  // 4
        i_b = 8'b11111100;  // -4
        i_cin = 0;          // Không có carry-in
    #10;  // Chờ 10 đơn vị thời gian

    // Kết thúc mô phỏng
    $finish;
  end

  // Quan sát tín hiệu đầu ra
  initial begin
    $monitor("Time=%0t | i_a=%b | i_b=%b | i_cin=%b | o_sum=%b | o_ovf=%b | o_carry=%b", 
             $time, i_a, i_b, i_cin, o_sum, o_ovf, o_carry);
  end

endmodule
