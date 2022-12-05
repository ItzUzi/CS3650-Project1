module Alu_Core(
	A,
	B,
	alu_control,
	result,
	zero
    );

input [31:0] A;  // operand1
input [31:0] B;  // operand2
input [2:0] alu_control; // ALU control input; determines what ALU operation to do
output reg [31:0] result;  // result of ALU operation
output wire zero; // used for beq;

assign zero = !(|result);  //logical negation bit-wise OR result; used for BEQ 

always @ (*)
begin
	case(alu_control)
	3'h2: result = A + B;  // add ALU control input
	3'h6: result = A - B;  // subtract ALU control input
	3'h0: result = A & B;  // AND ALU control input
	3'h1: result = A | B;  // OR ALU control input
	3'h4: result = ~(A | B);  // NOR ALU control input
	3'h7: result = (A < B);  // set on less than ALU control input
	default: result = A + B;
	endcase
end
endmodule