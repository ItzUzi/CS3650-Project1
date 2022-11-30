module Alu_Control(
	opcode,
	func_field,
	alu_control
    );
	 
input [5:0] opcode;
input [5:0] func_field;
output reg [2:0] alu_control;
reg [2:0] func_code;

always @ (*)
begin
	case (func_field)
	6'h20: func_code = 3'h0;
	6'h22: func_code = 3'h1;
	6'h24: func_code = 3'h2;
	6'h25: func_code = 3'h3;
	6'h27: func_code = 3'h4;
	6'h2A: func_code = 3'h5;
	default: func_code = 3'h0;
	endcase

	case (opcode)
	6'h00: alu_control = func_code;
	6'h04: alu_control = 3'h1;
	6'h23: alu_control = 3'h0;
	6'h2B: alu_control = 3'h0;
	default: alu_control = 3'h0;
	endcase
end
endmodule