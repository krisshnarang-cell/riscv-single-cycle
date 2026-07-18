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

Once the value is stored at rd, the cycle begins again...
