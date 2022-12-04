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
	case (func_field)  //for R-type instructions; other instructions they are don't cares
	/* Desired ALU action*/
	6'h20: func_code = 3'h2;  // add
	6'h22: func_code = 3'h6;  // subtract
	6'h24: func_code = 3'h0;  // AND
	6'h25: func_code = 3'h1;  // OR
	6'h27: func_code = 3'h4;  // NOR
	6'h2A: func_code = 3'h7;  // set on less than (SLT)
	default: func_code = 3'h0; // add when LW or SW since don't cares
	endcase

	case (opcode)
	6'h00: alu_control = func_code;  // for all R-type instruction
	6'h04: alu_control = 3'h1;  // beq 
	6'h23: alu_control = 3'h0;  // lw
	6'h2B: alu_control = 3'h0;  // sw 
	default: alu_control = 3'h0;
	endcase
end
endmodule