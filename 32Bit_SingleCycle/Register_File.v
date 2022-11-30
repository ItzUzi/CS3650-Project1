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
input [4:0] read_addr1;
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

endmodule