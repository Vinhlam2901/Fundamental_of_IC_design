module FullSub_1bit (
    input  logic a,
    input  logic b,
    input  logic bin,
    output logic bout
);
    assign bout = ((~a) & b) | ((~(a ^ b)) & bin);
endmodule
