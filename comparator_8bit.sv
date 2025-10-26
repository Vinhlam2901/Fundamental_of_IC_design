module comparator_8bit (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [7:0] Min,
    output logic [7:0] Max
);
    wire borrow_out;
    subtractor_8bit sub8 (
        .A(A),
        .B(B),
        .BORROW_OUT(borrow_out)
    );
  always_comb begin
    Min =(borrow_out) ? A : B;
    Max =(borrow_out) ? B : A;
  end
endmodule
