module datapath(  //PC + PC_addr + inst_mem
    input clk,
    input reset
);
wire [31:0] pc_out;
wire [31:0] pc_next;
wire [31:0] imm;
wire [31:0] pc_plus_4;
wire [31:0] branch_trgt_addr;
wire [31:0] inst;

pc pc(
    .clk(clk),
    .reset(reset),
    .pc(pc_out),
    .pc_next(pc_next)
);

pc_adder pcadd(
    .pc(pc_out),
    .imm(imm),
    .pc_plus_4(pc_plus_4),
    .branch_trgt_addr(branch_trgt_addr)
);

inst_mem inst_mem(
    .pc(pc_out),
    .inst(inst)
);
//Control Unit + immediate_generator + register file
    wire [6:0] opcode = inst[6:0];
    wire AluSrc;
    wire RegWrite;
    wire MemtoReg;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire [1:0] AluOp;
    wire [2:0] funct3 = inst[14:12];
    wire funct7_bit = inst[30];

    control_unit cu(
        .opcode(opcode),
        .AluSrc(AluSrc),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .AluOp(AluOp)
    );

    immediate_generator immgen(
        .AluOp(AluOp),
        .inst(inst),
        .opcode(opcode),
        .imm(imm)
    );

    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rs2 = inst[24:20];
    wire [4:0] rd = inst[11:7];
    wire [31:0] regf_write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    reg_file rf(
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .regf_write_data(regf_write_data),
        .reg_write(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .clk(clk)
    );
    wire [3:0] alu_op;
    wire [31:0] from_mux1;
    wire [31:0] to_mux2;
    wire zero_bit;

    alu_control alutrl(
        .AluOp(AluOp),
        .funct3(funct3),
        .funct7_bit(funct7_bit),
        .alu_op(alu_op)
    );

    alu alu(
        .read_data1(read_data1),
        .from_mux1(from_mux1),
        .alu_op(alu_op),
        .to_mux2(to_mux2),
        .zero_bit(zero_bit)
    );

    mux1 mux1(
        .read_data2(read_data2),
        .imm(imm),
        .AluSrc(AluSrc),
        .from_mux1(from_mux1)
    );

//Load(Mux2 + dmem + pc_next_mux)

    wire [31:0] read_data;

    mux2 mux2(
        .alu_result(to_mux2),
        .read_data(read_data),
        .write_data(regf_write_data),
        .MemtoReg(MemtoReg)
    );

    data_memory dmem(
        .addr(to_mux2),
        .dmem_write_data(read_data2),
        .read_data(read_data),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .clk(clk)
    );

    pc_next_mux pc_next_muc(
       .pc_plus_4(pc_plus_4),
       .branch_trgt_addr(branch_trgt_addr),
       .pc_next(pc_next),
       .branch(Branch),
       .zero_bit(zero_bit)
    );

endmodule