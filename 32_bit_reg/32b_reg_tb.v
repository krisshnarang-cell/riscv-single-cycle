module tb_reg_file;
    // Wires and registers
    reg clk;
    reg regWrite;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    // Connect the module
    reg_file uut (
        .clk(clk), .regWrite(regWrite),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wd(wd), .rd1(rd1), .rd2(rd2)
    );

    // Generate the clock
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Setup visual waveform
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_reg_file);

        // Setup text console output
        $monitor("Time: %0t | clk: %b | Unlock: %b | Write_to: %d | Data_in: %d || Read_1: %d | Read_2: %d", 
                 $time, clk, regWrite, rd, wd, rd1, rd2);

        // Initialize to 0
        clk = 0; regWrite = 0; rs1 = 0; rs2 = 0; rd = 0; wd = 0;
        #10; 

        // Test 1: Write 99 to locker 5
        regWrite = 1;      
        rd = 5'd5;         
        wd = 32'd99;       
        #10;               
        regWrite = 0;      

        // Read locker 5
        rs1 = 5'd5;        
        #10;               

        // Test 2: Try to write 500 to locker 0 (Should fail!)
        regWrite = 1;
        rd = 5'd0;         
        wd = 32'd500;      
        #10;
        
        // Read locker 0
        rs2 = 5'd0;        
        #10;

        $finish;           
    end
endmodule