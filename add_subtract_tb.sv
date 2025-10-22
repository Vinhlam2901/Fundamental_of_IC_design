module add_subtract_tb;

    // Khai báo các tín hiệu cho module DUT (Device Under Test)
    reg  [7:0]  a_i;
    reg  [7:0]  b_i;
    reg         add_sub;
    wire [7:0]  result_o;
    wire        cout_o;

    // Khởi tạo Module DUT
    add_subtract DUT (
        .a_i      (a_i),
        .b_i      (b_i),
        .add_sub  (add_sub),
        .result_o (result_o),
        .cout_o   (cout_o),
        .o_ovf    (o_ovf) // Tín hiệu mới
    );

    // Khởi tạo ban đầu
    initial begin
        // Khởi tạo các giá trị đầu vào
        a_i     = 8'h00;
        b_i     = 8'h00;
        add_sub = 1'b0;

        // Chờ 10 ns để ổn định ban đầu
        #10; 

  // =======================================================
        // 1. KIỂM TRA PHÉP CỘNG (add_sub = 0)
        // =======================================================
        $display("--- Bắt đầu kiểm tra Phép Cộng (add_sub = 0) ---");
        add_sub = 1'b0; // Thiết lập chế độ Cộng
        #10;

        // Test 1.1: Cộng bình thường: 5 + 3 = 8
        a_i = 8'd5;
        b_i = 8'd3;
        // Kết quả: 8 (dương). Không tràn.
        #10 $display("Cộng: %0d + %0d = %0d. Cout: %b, Ovf: %b. (Exp: 8, Cout: 0, Ovf: 0)", a_i, b_i, result_o, cout_o, o_ovf);

        // Test 1.2: Cộng GÂY TRÀN (Overflow): 70 + 70 = 140 (dương -> âm)
        // Lưu ý: 140 trong Bù 2 là số âm (-116)
        a_i = 8'd70;  // 0x46 (Dương)
        b_i = 8'd70;  // 0x46 (Dương)
        // Expected: 140 (0x8C). Bit dấu bật lên (0x80 trở lên). Ovf = 1.
        #10 $display("Cộng: %0d + %0d = %0d. Cout: %b, Ovf: %b. (Exp: 140/0x8C, Cout: 0, Ovf: 1)", a_i, b_i, result_o, cout_o, o_ovf);
        
        // Test 1.3: Cộng GÂY TRÀN (Overflow): (-70) + (-70) = -140 (âm -> dương)
        a_i = 8'd186; // -70 (Âm)
        b_i = 8'd186; // -70 (Âm)
        // Expected: 116 (0x74). Bit dấu tắt đi. Ovf = 1.
        #10 $display("Cộng: %0d + %0d = %0d. Cout: %b, Ovf: %b. (Exp: 116/0x74, Cout: 1, Ovf: 1)", a_i, b_i, result_o, cout_o, o_ovf);
        
        // =======================================================
        // 2. KIỂM TRA PHÉP TRỪ (add_sub = 1)
        // =======================================================
        $display("--- Bắt đầu kiểm tra Phép Trừ (add_sub = 1) ---");
        add_sub = 1'b1; // Thiết lập chế độ Trừ (A - B)
        #10;

        // Test 2.1: Trừ bình thường: 8 - 3 = 5
        a_i = 8'd8;
        b_i = 8'd3;
        // Kết quả: 5 (dương). Không tràn.
        #10 $display("Trừ: %0d - %0d = %0d. Cout: %b, Ovf: %b. (Exp: 5, Cout: 1, Ovf: 0)", a_i, b_i, result_o, cout_o, o_ovf);
        
        // Test 2.2: Trừ ra âm (Không tràn): 5 - 10 = -5 (0xFB)
        a_i = 8'd5;
        b_i = 8'd10;
        // Kết quả: 251 (âm). Không tràn.
        #10 $display("Trừ: %0d - %0d = %0d. Cout: %b, Ovf: %b. (Exp: 251/0xFB, Cout: 0, Ovf: 0)", a_i, b_i, result_o, cout_o, o_ovf);
        
        // Test 2.3: Trừ GÂY TRÀN (Overflow): 70 - (-70) = 140 (dương -> âm)
        a_i = 8'd70;   // 0x46 (Dương)
        b_i = 8'd186;  // -70 (Âm)
        // Trừ số âm tương đương với cộng số dương (70 + 70). Ovf = 1.
        #10 $display("Trừ: %0d - %0d = %0d. Cout: %b, Ovf: %b. (Exp: 140/0x8C, Cout: 0, Ovf: 1)", a_i, b_i, result_o, cout_o, o_ovf);

        // Kết thúc mô phỏng
        $display("--- Kết thúc mô phỏng ---");
        $finish;
    end

endmodule