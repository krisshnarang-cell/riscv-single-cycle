module reg_file(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] regf_write_data,
    input clk,
    input reg_write,
    output [31:0] read_data1,
    output [31:0] read_data2
);
//declaring array of registers
reg [31:0] registers [0:31];
//read part
assign read_data1 = (rs1==0) ? 32'b0 : registers[rs1];
assign read_data2 = (rs2==0) ? 32'b0 : registers[rs2];

//write part
always@(posedge clk) begin
    if(reg_write == 1) begin
            registers[rd] <= regf_write_data;
    end
end

endmodule