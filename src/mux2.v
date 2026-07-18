module mux2(
    input [31:0] alu_result,
    input [31:0] read_data,
    input MemtoReg,
    output [31:0] write_data
);

assign write_data = MemtoReg ? read_data : alu_result;

endmodule