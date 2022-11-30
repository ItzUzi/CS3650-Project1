module Alu_Top(
	opcode,
	func_field,
	A,
	B,
	result,
	zero
    );

input [5:0] opcode;
input [5:0] func_field;
input [31:0] A;
input [31:0] B;
output [31:0] result;
output zero;
wire [2:0] alu_control;

Alu_Control alu_ctrlr_inst (
.opcode (opcode),
.func_field (func_field),
.alu_control (alu_control)
);

Alu_Core alu_core_inst (
.A (A),
.B (B),
.alu_control (alu_control),
.result (result),
.zero (zero)
);

endmodule