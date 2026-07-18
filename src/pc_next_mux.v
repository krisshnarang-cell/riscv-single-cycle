module pc_next_mux(
    input [31:0] pc_plus_4,
    input [31:0] branch_trgt_addr,
    output [31:0] pc_next,
    input branch,
    input zero_bit
);

assign pc_next = ((branch & zero_bit) == 1) ? branch_trgt_addr : pc_plus_4;

endmodule