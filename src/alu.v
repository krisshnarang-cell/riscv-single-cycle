//ALU
module alu_control(
    input  [1:0] AluOp,
    input  [2:0] funct3,
    input        funct7_bit,     
    output reg  [3:0] alu_op         
);

always@(*) begin
    case (AluOp)
    2'b00: alu_op = 4'b0001;//add (lw/sw/addi)
    2'b01: alu_op = 4'b0010;//sub (beq)
    2'b10: begin  // R-type
    case (funct3)
        3'b000: alu_op = (funct7_bit==0)? 4'b0001 /*ADD*/ : 4'b0010 /*SUB*/;
        3'b111: alu_op = 4'b0100;  // AND
        3'b110: alu_op = 4'b1000;  // OR
        3'b100: alu_op = 4'b0011;  // XOR
        default: alu_op = 4'b0;
    endcase
end
    endcase
end
endmodule

module alu(
    input [31:0] read_data1,
    input [31:0] from_mux1,
    input [3:0] alu_op,
    output reg [31:0] to_mux2,
    output zero_bit
);

always@(*) begin
    case(alu_op)
        4'b0001 : to_mux2 = read_data1 + from_mux1;
        4'b0010 : to_mux2 = read_data1 - from_mux1;
        4'b0011 : to_mux2 = read_data1 ^ from_mux1;
        4'b1000 : to_mux2 = read_data1 | from_mux1;
        4'b0100 : to_mux2 = read_data1 & from_mux1;
        default : to_mux2 = 32'b0;
    endcase
end

assign zero_bit = (to_mux2==0) ? 1 : 0;

endmodule
// connecting both modules
module alu_top(
    input [31:0] inst,
    input [1:0] AluOp,
    input [31:0] read_data1,
    input [31:0] from_mux1,
    output [31:0] to_mux2
);
wire [3:0] alu_op;
alu_control control (.AluOp(AluOp), .funct3(inst[14:12]), .funct7_bit(inst[30]), .alu_op(alu_op));

alu execut (.read_data1(read_data1), .from_mux1(from_mux1), .alu_op(alu_op), .to_mux2(to_mux2));

endmodule