RISC-V Single-Cycle Microprocessor

This microprocessor supports R-Type (add, sub, and, or, xor), I-Type (addi, load word), S-Type (store word), and B-Type (branch) instructions. R-Type instructions are designed so more can easily be added in the future.

This is a single-cycle microprocessor — as the name suggests, it completes every instruction (fetch → decode → fetch operands → execute → store value) in one clock cycle.

Modules

Program Counter (PC)
Takes clk, reset, and pc_next as input and gives pc as output. If reset=1 → pc=0, and if reset=0 → pc=pc_next.

pc_addr
Takes pc and immediate as input and outputs pc+4 and pc+immediate.

pc_next_mux
Based on whether to take a branch or not, it assigns pc_next to pc+4 or pc+immediate.

Instruction Memory
Takes pc as input and gives the instruction present at that address. In this module, I declared an array to store 256 instructions and then extracted instructions from this array according to the demand of PC.

Control Unit
Takes the opcode as input and, based on that, it gives values to AluOP, AluSrc, RegWrite, MemRead, MemWrite, Branch, and MemtoReg.

Reg File
Takes the addresses of rs1, rs2, and rd, the data to be written after computation, clk (as writing to a register is synchronous), and outputs read_data1 and read_data2 (the values stored at rs1 and rs2, respectively).

Immediate Generator
Takes the 32-bit instruction and, based on instruction type, extracts a 12-bit (11-bit in case of B-Type) immediate and sign-extends it to 32 bits.

MUX1
Selects between read_data2 and imm based on AluSrc and gives the selected value to the ALU.

ALU
In the ALU, we have two separate modules defined: alu_control and alu.


alu_control: Takes AluOP and funct3 (inst[14:12]), funct7 (inst[7]) as input and then decides alu_op. This is needed because for R-Type instructions, all the instructions (add, sub, or, and, xor) have the same AluOP, so to differentiate among them, we use this.
alu: Takes alu_op as input and, based on that, decides which operation to perform.


Data Memory
Takes value from read_data2 if it is a store_word instruction; gives value to MUX2 if it is a load_word instruction.

MUX2
Selects among the value coming from ALU and Data Memory based on MemtoReg, and gives the value to the Register File to store at rd.

Once the value is stored in rd, the cycle repeats...

Sample execution trace

Program: addi x1,x0,5 → add x2,x1,x1 → sw x1,0(x0) → lw x2,0(x0) → beq x1,x2,8

At t=0, all ports hold garbage values (x).

t=5, reset=1: pc=0, instruction is addi x1,x0,5. AluOp=00, alu_op=0001 (add), read_data1=0, from_mux1=5 → ALU computes to_mux2=5, written to x1.

Writes and PC updates only happen on posedge clk, so the next instruction's effects appear starting at t=15.

t=15, reset=0: pc=4, instruction is add x2,x1,x1. AluOp=10, alu_op=0001, read_data1=5, from_mux1=5 → ALU computes to_mux2=10, written to x2.

t=25, reset=0: pc=8, instruction is sw x1,0(x0) — stores x1 into mem[x0+0]. AluOp=00, alu_op=0001, read_data2=5 (value to store), read_data1=0, from_mux1=0 → address computes to 0, and 5 is written into mem[0].

t=35, reset=0: pc=12, instruction is lw x2,0(x0) — loads mem[x0+0] into x2. AluOp=00, alu_op=0001, read_data1=0, from_mux1=0 → address 0, and x2 is updated to 5 (the value stored earlier), confirming the store/load round-trip.

t=45, reset=0: pc=16, instruction is beq x1,x2,8. AluOp=01, alu_op=0010 (subtract), read_data1=5, read_data2=5, from_mux1=5 → ALU computes to_mux2=0, zero_bit=1. Since x1==x2, the branch is taken, and PC jumps from 16 to 24 instead of 20.
