module Data_Memory(
	clk,
	address,
	write_en,
	write_data,
	read_data
    );
	 
input clk;  // clock
input [31:0] address;  // register address to be loaded to or written to
input write_en;  // 1 if data is written, 0 if data is not to be written
input [31:0] write_data; // 32 bit data that will be written to register address
output wire [31:0] read_data;  // data to be loaded from reg address

//Registers are addressed as per MIPS register table
reg [7:0] data_mem [0:31];
										
initial begin
$readmemh("data_memory.mem", data_mem);
end

assign read_data = {data_mem[address+3],data_mem[address+2],
		     data_mem[address+1],data_mem[address]};

always @ (posedge clk)  // every time clk goes from 0 to 1
begin
/* If write_en is high (== 1), then write data to memory 
*  Else, keep the same value in data memory
*/
data_mem[address]   <= write_en ? write_data[7:0]   : data_mem[address];
data_mem[address+1] <= write_en ? write_data[15:8]  : data_mem[address+1];
data_mem[address+2] <= write_en ? write_data[23:16] : data_mem[address+2];
data_mem[address+3] <= write_en ? write_data[31:24] : data_mem[address+3];
end

endmodule