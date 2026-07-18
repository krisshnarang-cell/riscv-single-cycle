module reg_file_tb;

    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] write_data;
    reg clk;
    reg reg_write;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    reg_file uut (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .clk(clk),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
initial clk = 0;
always #5 clk = ~clk;

initial begin
    // Test 1: write 25 into x5, then read it back
    reg_write = 1;
    rd = 5;
    write_data = 32'd25;
    @(posedge clk);      // wait for the clock edge — this is when the write actually latches
    #1
    reg_write = 0;       // turn off write so we're just reading now
    rs1 = 5;
    #1;                  // small delay to let the combinational read settle
    $display("Test 1: registers[5] = %d (expected 25)", read_data1);

    // Test 2: Write 99 into x0 (address 0), then read rs1 = 0 — expected result should be 0 (since x0 always reads zero, write should be discarded)
    reg_write = 1;
    rd = 0;
    write_data = 32'd99;
    @(posedge clk);

    reg_write = 0;
    rs1=0;
    #1
    $display("Test 2: registers[0] =%d (expected 0)",read_data1);


    $finish;
end

endmodule