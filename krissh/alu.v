//ALU
module alu_control(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7_bit,     
    output reg  [3:0] alu_op         
);

always@(*) begin
    case (ALUOp)
    2'b00: alu_op = 4'b0100;//add (lw/sw)
    2'b01: alu_op = 4'b0011;//sub (beq)
    2'b11: alu_op = 4'b0100;//add (addi)
    2'b10: begin  // R-type
    case (funct3)
        3'b000: alu_op = funct7_bit ? 4'b0011 /*SUB*/ : 4'b0100 /*ADD*/;
        3'b100: alu_op = 4'b0101;  // XOR
        3'b110: alu_op = 4'b0110;  // OR
        3'b111: alu_op = 4'b0111;  // AND
        default: alu_op = 4'b0;
    endcase
end
    endcase
end
endmodule

module alu(
    input [31:0] rs1,
    input [31:0] from_mux1,
    input [3:0] alu_op,
    output reg [31:0] to_mux2
);

always@(*) begin
    case(alu_op)
        4'b0100 : to_mux2 = rs1 + from_mux1;
        4'b0011 : to_mux2 = rs1 - from_mux1;
        4'b0101 : to_mux2 = rs1 ^ from_mux1;
        4'b0110 : to_mux2 = rs1 | from_mux1;
        4'b0111 : to_mux2 = rs1 & from_mux1;
        default : to_mux2 = 32'b0;
    endcase
end
endmodule
// connecting both modules
module alu_top(
    input [31:0] inst;
    input [1:0] ALUOp;
    input [31:0] rs1;
    input [31:0] from_mux1;
    output [31:0] to_mux2;
);

alu_control control (.ALUOp(ALUOp), .funct2(inst[14:12]), .funct7_bit(inst[30]), .alu_op(alu_op));

alu execut (.rs1(rs1), .from_mux1(from_mux1), .alu_op(alu_op), .to_mux2(to_mux2));

endmodule