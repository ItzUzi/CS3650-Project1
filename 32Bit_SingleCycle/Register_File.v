module Register_File( 	// Changes values of registers based on clock cycle and what register is being used by opodes
	clk,
	rst_n,
	read_addr1,
	read_addr2,
	write_en,
	write_addr,
	write_data,
	read_data1,
	read_data2
    );

input clk;
input rst_n;
input [4:0] read_addr1;  // each 5 bit address correlates to an instruction of 32-bit width
input [4:0] read_addr2; 
input write_en;
input [4:0] write_addr;	// address that will be rewritten within reg_mem
input [31:0] write_data;

output wire [31:0] read_data1;
output wire [31:0] read_data2;

reg [31:0] reg_mem [31:0]; // Holds 32 Registers

initial begin
$readmemh("reg_memory.mem", reg_mem); //Load initial values
end

assign read_data1 = reg_mem[read_addr1];
assign read_data2 = reg_mem[read_addr2];

always @ (posedge clk or negedge rst_n)		// Runs anytime clock is changed
begin										// if clock changes from 1->0 then pushes reg_mem[write_address] value further into FlipFlop
if (!rst_n)									
begin
reg_mem[write_addr] <= reg_mem[write_addr];	 
end											// if clock changes from 0->1 then checks the bit write_en
else										// pushes write_data or reg_mem[write_addr] to flipflop
begin
reg_mem[write_addr] <= write_en ? write_data : reg_mem[write_addr];
end
end

assign addr_incr = (!rst_n) ? 32'd0 : 32'd4;
assign final_write_en = (!rst_n) ? 1'b0 : ctrl_write_en;

Program_Counter prg_cntr (
.clk (clk),
.rst_n (rst_n),
.in_address (ctrl_in_address),
.out_address (out_address)	
);

Adder adder_next_addr (
.in1 (out_address),
.in2 (addr_incr),
.out (address_plus_4)
);

Adder adder_branch_addr (
.in1 (address_plus_4),
.in2 (branch_addr_offset),
.out (branch_address)
);

Instruction_Memory instr_mem (
.instrn_address (out_address),
.instrn (instrn[31:0])
);

Register_File regfile (
.clk (clk),
.rst_n (rst_n),
.read_addr1 (instrn[25:21]),
.read_addr2 (instrn[20:16]), 
.write_en   (final_write_en),
.write_addr (ctrl_write_addr),
.write_data (ctrl_regwrite_data),
.read_data1 (read_data1),
.read_data2 (read_data2)
);

Sign_Extension sign_ext (
.bits16_in (instrn[15:0]),
.bits32_out (sign_ext_out)
);

Shifter shifter (
.indata (sign_ext_out),
.shift_amt (2'd2),
.shift_left (1'b1),
.outdata (branch_addr_offset)
);

Alu_Top alu (
.opcode (instrn[31:26]),
.func_field (instrn[5:0]),
.A (read_data1),
.B (ctrl_aluin2),
.result (alu_result),
.zero (zero_out)
);

Data_Memory data_mem (
.clk		(clk),
.address (alu_result),
.write_en (ctrl_datamem_write_en),
.write_data (read_data2),
.read_data (datamem_read_data)
);

Control_Logic ctrl_logic (
.instrn			  (instrn),
.instrn_opcode   (instrn[31:26]),
.address_plus_4  (address_plus_4),
.branch_address  (branch_address),
.ctrl_in_address (ctrl_in_address),
.alu_result      (alu_result),
.zero_out        (zero_out),
.ctrl_write_en   (ctrl_write_en),
.ctrl_write_addr (ctrl_write_addr),
.read_data2      (read_data2),
.sign_ext_out    (sign_ext_out),
.ctrl_aluin2     (ctrl_aluin2),
.ctrl_datamem_write_en (ctrl_datamem_write_en),
.datamem_read_data (datamem_read_data),
.ctrl_regwrite_data (ctrl_regwrite_data)
);



endmodule