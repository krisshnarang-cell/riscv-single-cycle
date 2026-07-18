module full_adder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

assign Sum=A^B^Cin;
assign Cout = (A & B) | (Cin & (A ^ B));

endmodule

module ripplecarryadder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire c1,c2,c3;
 
full_adder FA0(A[0],B[0],Cin,Sum[0],c1);
full_adder FA1(A[1],B[1],c1,Sum[1],c2);
full_adder FA2(A[2],B[2],c2,Sum[2],c3);
full_adder FA3(A[3],B[3],c3,Sum[3],Cout);

endmodule

module test();
reg[3:0] A;
reg[3:0] B;
reg Cin;
wire[3:0] Sum;
wire Cout;

ripplecarryadder g1(A,B,Cin,Sum,Cout);

initial begin
    $display("A + B = Sum | Cout");

    $monitor("%b + %b = %b | %b",A,B,Sum,Cout);

    Cin=0;

    A=4'b1000;B=4'b0010;#5;
    A=4'b0001;B=4'b0100;#5;
    A=4'b0110;B=4'b1110;#5;

end


endmodule
