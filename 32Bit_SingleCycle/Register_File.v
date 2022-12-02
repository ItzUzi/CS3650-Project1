module Register_File(
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
input [4:0] write_addr;
input [31:0] write_data;

output wire [31:0] read_data1;
output wire [31:0] read_data2;

reg [31:0] reg_mem [31:0];

initial begin
$readmemh("reg_memory.mem", reg_mem); //Load initial values
end

assign read_data1 = reg_mem[read_addr1];
assign read_data2 = reg_mem[read_addr2];

always @ (posedge clk or negedge rst_n)
begin
if (!rst_n)
begin
reg_mem[write_addr] <= reg_mem[write_addr];
end
else
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


endmodule