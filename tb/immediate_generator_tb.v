module immediate_generator_tb();
    reg [1:0] AluOp;
    reg [31:0] inst;
    reg [6:0] opcode;
    wire [31:0] imm;

    immediate_generator uut(
        .AluOp(AluOp),
        .inst(inst),
        .opcode(opcode),
        .imm(imm)
    );

    initial begin

        opcode = 7'b0000011;
        #5
        inst = {12'd5,20'b0};
        $monitor("imm = %b",imm);

        $finish;
    end
endmodule