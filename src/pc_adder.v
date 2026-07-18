module pc_adder(
    input [31:0] pc,
    input [31:0] imm,
    output [31:0] pc_plus_4,
    output [31:0] branch_trgt_addr
);
assign pc_plus_4 = pc+4;
assign branch_trgt_addr = pc + imm;
endmodule