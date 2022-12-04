module Alu_Top_tb;

// Inputs
reg [5:0] opcode;
reg [5:0] func_field;
reg [31:0] A;
reg [31:0] B;

// Outputs
wire [31:0] result;
wire zero;

// Instantiate the Unit Under Test (UUT)
Alu_Top uut (
	.opcode(opcode), 
	.func_field(func_field), 
	.A(A), 
	.B(B), 
	.result(result),
	.zero(zero)
);

initial begin
	$dumpfile("alu_top.vcd");
	$dumpvars();

	// Initialize Inputs
	opcode = 0;
	func_field = 0;
	A = 0;
	B = 0;
	
	#30; // ADD
	A=32'h2222; B=32'h1111;
	opcode=6'h00;func_field=6'h20; 
	#30; // AND
	opcode=6'h00;func_field=6'h24;
	#30; // LW
	opcode=6'h23;func_field=6'h00;
	#30; // BEQ
	A=31'h5555; B=32'h5555;
	opcode=6'h04;func_field=6'h00;
	#30; // SLT
	A=32'h1111; B=32'h2222;
	opcode=6'h00;func_field=6'h2A;
	#30; // OR
	opcode=6'h00;func_field=6'h25;
	#30; // OR
	A=32'h1111; B=32'h3333;
	#30; // OR
	A=32'h9210; B=32'h3338;
	#30; // NOR
	A=32'h1111; B=32'h2222;
	opcode=6'h00;func_field=6'h27;
	#30; // Subtract
	A=32'h2222; B=32'h1111;
	opcode=6'h00;func_field=6'h22;
	#30;
	$finish;
end
      
endmodule