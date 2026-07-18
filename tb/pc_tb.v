module pc_tb;
  reg clk;
  reg reset;
  wire [31:0] pc;

  pc uut(
    .clk(clk),
    .reset(reset),
    .pc(pc)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("time=%0t reset=%b pc=%d", $time, reset, pc);

    reset = 1;   // hold reset active
    #12;         // cross at least one posedge clk while reset is high
    reset = 0;   // release reset, PC should start incrementing

    #50;         // let several clock cycles pass, watch pc go 0,4,8,12...

    $finish;
  end

endmodule