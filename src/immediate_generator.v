module immediate_generator(
    input [1:0] AluOp,
    input [31:0] inst,
    input [6:0] opcode,
    output reg [31:0] imm
);
always@(*) begin
    case(opcode) 
         7'b0000011 : begin //I-Type(L)
            imm = {{20{inst[31]}},{inst[31:20]}};
         end

         7'b0100011: begin //I-Type(S)
            imm = {{20{inst[31]}},{inst[31:25]},{inst[11:7]}};
         end

         7'b0010011 : begin //I-Type(ADDI)
            imm = {{20{inst[31]}},{inst[31:20]}};
         end

         7'b1100011 : begin //B-Type
            imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
         end

         default : begin
            imm = 32'b0;
         end

    endcase
end

endmodule