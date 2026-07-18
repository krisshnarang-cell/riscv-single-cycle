module control_unit_tb();
    reg [6:0] opcode;
    wire AluSrc;
    wire RegWrite;
    wire MemtoReg;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire [1:0] AluOp;

    control_unit uut(
        .opcode(opcode),
        .AluSrc(AluSrc),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .AluOp(AluOp)
    );
    initial begin
        $monitor("opcode = %b,AluSrc = %b,RegWrite = %b",opcode,AluSrc,RegWrite);

        opcode = 7'b0110011;
        #10
        opcode = 7'b0000011;

        $finish;

    end
endmodule