module mux1(
    input [31:0] read_data2,
    input [31:0] imm,
    input AluSrc,
    output [31:0] from_mux1
);
assign from_mux1 = AluSrc ? imm : read_data2;

endmodule