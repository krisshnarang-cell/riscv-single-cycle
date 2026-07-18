module datapath_tb();
  reg clk;
  reg reset;

  initial clk = 0;
  always #5 clk = ~clk;

  datapath dp(
    .clk(clk),
    .reset(reset)
  );

  initial begin
    $readmemh("program.hex", dp.inst_mem.mem);

   $monitor("time=%0t pc=%d inst=%h AluOp=%b alu_op=%b read_data1=%d read_data2=%d from_mux1=%d to_mux2=%d zero_bit=%b", 
    $time, dp.pc_out, dp.inst, dp.AluOp, dp.alu_op, dp.read_data1, dp.read_data2, dp.from_mux1, dp.to_mux2, dp.zero_bit);
    reset = 1;
    #12;
    reset = 0;

    #50;

    $finish;
  end

endmodule

// 1) add x1,x0,5;
