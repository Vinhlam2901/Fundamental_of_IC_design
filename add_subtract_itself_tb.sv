module add_subtract_itself_tb;

    // Khai báo Clock, Reset và các tín hiệu đầu vào/ra
    reg         i_clk;
    reg         ni_rst;
    reg         add_sub;
    reg  [7:0]  i_a;
    wire        o_carry;
    wire        o_ovf;


    // Khởi tạo Clock (Tần số 100 MHz, chu kỳ 10 ns)
    initial begin
        i_clk = 1'b0;
        forever #5 i_clk = ~i_clk; // Chu kỳ 10 ns
    end

    // Khởi tạo Module DUT (Device Under Test)
    add_subtract_itself dut (
        .i_clk    (i_clk),
        .ni_rst   (ni_rst),
        .add_sub  (add_sub),
        .i_a  (i_a),
        .o_carry  (o_carry),
        .o_ovf    (o_ovf)
    );

    // Khối kiểm thử (Stimulus)
    initial begin

        // 1. RESET
        $display("--- Bắt đầu Test: Reset ---");
        ni_rst  = 1'b0; // Kích hoạt Reset (Active-low)
        add_sub = 1'b0;
        i_a     = 8'h00;
        #20;
        ni_rst  = 1'b1; // Hủy Reset
        #10 $display("Sau Reset: dut.o_a= %d, o_a = %d (Exp: 0)", dut.o_a, dut.o_a);


        // 2. KIỂM TRA CỘNG TÍCH LŨY (add_sub = 0)
        $display("--- Kiểm tra Cộng Tích Lũy (S = S + A) ---");
        add_sub = 1'b0;

        // Cycle 1: S = 0 + 5 = 5
        i_a = 8'd5;
        #10 $display("S = S + 5. o_a = %d S = %0d, Carry = %b, Ovf = %b",dut.o_a, dut.o_a, o_carry, o_ovf); 

        // Cycle 2: S = 5 + 10 = 15
        i_a = 8'd10;
        #10 $display("S = S + 10. S = %0d, Carry = %b, Ovf = %b", dut.o_a, o_carry, o_ovf); 

        // Cycle 3: S = 15 + 15 = 30
        i_a = 8'd15;
        #10 $display("S = S + 15. S = %0d, Carry = %b, Ovf = %b", dut.o_a, o_carry, o_ovf); 


        // 3. KIỂM TRA CHẾ ĐỘ GI   $display("--- Kiểm tra Chế độ Gi;      i_a  = 8'd200; // Thay đổi A, nhưng không cập nhật S
        #10 $display("Giữ: S = %0d (Exp: 30)", dut.o_a);
        #10 $display("Giữ: S = %0d (Exp: 30)", dut.o_a);

        // 4. KIỂM TRA TRỪ TÍCH LŨY (add_sub = 1)
        $display("--- Kiểm tra Trừ Tích Lũy (S = S - A) ---");
        add_sub = 1'b1; // Chế độ Trừ
        ni_rst  = 1'b0; // Kích hoạt Reset (Active-low)

        i_a = 8'd00;
        #20;
        ni_rst  = 1'b1; // Hủy Reset
        // Cycle 4: S = 30 - 5 = 25
        i_a = 8'd5;
        #10 $display("S = S - 5.  S = %0d, Carry = %b, Ovf = %b", dut.o_a, o_carry, o_ovf); 

        // Cycle 5: S = 25 - 30 = -5 (251 trong Bù 2)
        i_a = 8'd30;
        #10 $display("S = S - 30. S= %0d (0x%h), Carry = %b, Ovf = %b", dut.o_a, dut.o_a, o_carry, o_ovf); 
        // Expected: 251/0xFB, Carry=0 (Borrow), Ovf=0

        
        // 5. KIỂM TRA TRÀN SỐ (Overflow)
        $display("--- Kiểm tra Tràn số (Overflow) ---");
        
        // Đặt lại S về số dương nhỏ: S = 10      i_a = 8'd0;
        ni_rst = 1'b0; 
        #20;
        ni_rst = 1'b1; 
        add_sub = 1'b0; 
        i_a = 8'd70;       #10; // S = 70
        
        // Cycle 6: S = 70 + 70 = 140 (dương + dương -> âm)
        // 140 decimal là 0x8C (Bit dấu = 1) -> OVERFLOW
        i_a = 8'd70;
        #10 $display("S = 70 + 70. S = %0d (0x%h), Carry = %b, Ovf = %b", dut.o_a, dut.o_a, o_carry, dut.o_ovf); 
        // Expected: 140/0x8C, Carry=0, Ovf=1

        
        // Cycle 7: S = 140 - 1 = 139 (âm - dương -> âm, không tràn)
        add_sub = 1'b1; // Trừ
        i_a = 8'd1;
        #10 $display("S = S - 1. S = %0d (0x%h), Carry = %b, Ovf = %b", dut.o_a, dut.o_a, o_carry, o_ovf); 
        // Expected: 139/0x8B, Carry=0, Ovf=0

        // Kết thúc mô phỏng
        $display("--- Kết thúc mô phỏng ---");
        #10;
        $finish;
    end

endmodule