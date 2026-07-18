module inst_mem(
    input [31:0] pc,
    output[31:0] inst
);
reg [31:0] mem [0:255];
assign inst = mem[pc[9:2]];

endmodule