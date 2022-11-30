module Alu_Core(
	A,
	B,
	alu_control,
	result,
	zero
    );

input [31:0] A;
input [31:0] B;
input [2:0] alu_control;
output reg [31:0] result;
output wire zero;

assign zero = !(|result);

always @ (*)
begin
	case(alu_control)
	3'h0: result = A + B;
	3'h1: result = A - B;
	3'h2: result = A & B;
	3'h3: result = A | B;
	3'h4: result = ~(A | B);
	3'h5: result = (A < B);
	default: result = A + B;
	endcase
end
endmodule