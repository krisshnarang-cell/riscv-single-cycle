module control_unit(
    input [6:0] opcode,
    output reg AluSrc,
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] AluOp
);
always @(*) begin
    case(opcode)
        7'b0110011 : begin
            AluSrc = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            AluOp = 2'b10;
        end
        7'b0000011 : begin
            AluSrc = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            MemtoReg = 1;
            Branch = 0;
            AluOp = 2'b00;
        end
        7'b0100011 : begin
            AluSrc = 1;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            MemtoReg = 1;
            Branch = 0;
            AluOp = 2'b00;
        end
        7'b0010011 : begin
            AluSrc = 1;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            AluOp = 2'b00;
        end
        7'b1100011: begin
            AluSrc = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 1;
            AluOp = 2'b01;
        end

        default: begin
            AluSrc = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            AluOp = 2'b00;
        end

    endcase
end
endmodule