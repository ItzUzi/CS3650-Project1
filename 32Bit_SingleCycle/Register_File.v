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
input write_en;  // 1 if write, 0 no write
input [4:0] write_addr;	// address that will be rewritten within reg_mem
input [31:0] write_data;  //data that will be saved to reg

output wire [31:0] read_data1;  //data from reg1
output wire [31:0] read_data2;  // data from reg2

reg [31:0] reg_mem [0:31]; // Holds 32 Registers

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

endmodule