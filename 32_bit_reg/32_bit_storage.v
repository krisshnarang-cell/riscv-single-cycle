module ref_file(
    input clk,
    input regWrite,
    input [4:0] rs1 , rs2 , rd, // rs1 and rs2 are address of lockers from we are getting inputs and rd is address of locker in which we are storing output
    input [31:0] wd, // wd(write data)( it contains the output and inserts it into locker with address rd )
    output [31:0] rd1 , rd2 // these are the values which are stored in lockers rs1, rs2 and these values come as output and then given to (ALU)
);
endmodule

reg [31:0] rf [31:0] // creating 32 lockers with each of size 32 bits

assign rd1 = (rs1 == 5'b0) ? 32'b0 : rf[rs1]; // assign operator creates a wire immediately and rs1==5'b0 checks if the input is completely 0, ? operator answers to this question id result is true it answers with output 32'b0(32 zeroes) and if result is false it grabs value from locker rf
assign rd2 = (rs2 == 5'b0) ? 32'b0 : rf[rs2]; // similar thing for input rs2

always @(posedge clk) begin  // it gets activated when we move from 0 to 1 and also the input is not 5'b0

    if ( regWrite==1 && rd!=5'b0) begin
        
        rf[rd] <= wd; // it intructs that in the locker system rf go to locker rd (basically assume rd as index of output locker in the locker list rf) and then open the gates and store value wd("<=" this is Non-Blocking assignment symbol)

    end
end
