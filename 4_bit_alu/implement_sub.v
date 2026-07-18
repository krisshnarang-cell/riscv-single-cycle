module subtract(
    input A,
    input B,
    output C
);

assign C = A+(~B)+1;

endmodule

module test();
reg A;
reg B;
wire C;

subtract g1(A,B,C);

initial begin

    $display("A - B | result");

    $monitor("%b %b | %b",A,B,C);
    A=0;B=0;#5;
    A=0;B=1;#5;
    A=1;B=0;#5;
    A=1;B=1;#5;

end

endmodule