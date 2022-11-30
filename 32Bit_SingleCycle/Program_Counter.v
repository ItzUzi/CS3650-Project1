module Program_Counter(
	clk,
	rst_n,
	in_address,
	out_address
    );

input clk, rst_n;
input [31:0] in_address;
output reg [31:0] out_address;

always @ (posedge clk or negedge rst_n)
begin
  if(!rst_n)
  out_address <= 32'd0;
  else
  out_address <= in_address;
end

endmodule