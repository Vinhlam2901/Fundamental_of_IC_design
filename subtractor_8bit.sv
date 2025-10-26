module subtractor_8bit (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic       BORROW_OUT
);
    wire [8:0] borrow;
    assign borrow[0] = 1'b0;

    FullSub_1bit FS0 (.a(A[0]), .b(B[0]), .bin(borrow[0]), .bout(borrow[1]));
    FullSub_1bit FS1 (.a(A[1]), .b(B[1]), .bin(borrow[1]), .bout(borrow[2]));
    FullSub_1bit FS2 (.a(A[2]), .b(B[2]), .bin(borrow[2]), .bout(borrow[3]));
    FullSub_1bit FS3 (.a(A[3]), .b(B[3]), .bin(borrow[3]), .bout(borrow[4]));
    FullSub_1bit FS4 (.a(A[4]), .b(B[4]), .bin(borrow[4]), .bout(borrow[5]));
    FullSub_1bit FS5 (.a(A[5]), .b(B[5]), .bin(borrow[5]), .bout(borrow[6]));
    FullSub_1bit FS6 (.a(A[6]), .b(B[6]), .bin(borrow[6]), .bout(borrow[7]));
    FullSub_1bit FS7 (.a(A[7]), .b(B[7]), .bin(borrow[7]), .bout(borrow[8]));

    assign BORROW_OUT = borrow[8];
endmodule