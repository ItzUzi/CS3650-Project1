module Adder(in1, in2, out);
input [31:0] in1;  // operand1
input [31:0] in2;  // operand2
output [31:0] out;  // sum of operand1 and operand2
reg [31:0] out;
always@(in1,in2)   // executed whenever operand1/operand2 set or updated
begin
    out=in1+in2;
end
endmodule