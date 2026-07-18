module half_adder(
    input A,
    input B,
    output Sum,
    output Carry
);

assign Sum = A ^ B;
assign Carry = A & B;   

endmodule

module test();

    reg A;
    reg B;
    wire Sum;
    wire Carry;

    half_adder g1(A,B,Sum,Carry);

    initial begin
        $display("A B | Sum Carry");

        $monitor("%b %b %b %b",A,B,Sum,Carry);


        #5 A=0;B=0;
        #5 A=0;B=1;
        #5 A=1;B=0;
        #5 A=1;B=1;

    end

endmodule
