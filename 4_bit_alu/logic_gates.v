module gates(
    input A,
    input B,
    output C,
    output D
);

assign C = A | B;
assign D = A & B;

endmodule



module test;

reg A;
reg B;
wire C;
wire D;


gates g1(A,B,C,D);

initial begin

$display("A B | C D");

A=0; B=0; #5;
$display("%b %b | %b %b",A,B,C,D);

A=0; B=1; #5;
$display("%b %b | %b %b",A,B,C,D);

A=1; B=0; #5;
$display("%b %b | %b %b",A,B,C,D);

A=1; B=1; #5;
$display("%b %b | %b %b",A,B,C,D);

end

endmodule
