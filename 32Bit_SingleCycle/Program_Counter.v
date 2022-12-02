module Program_Counter(
	clk,
	rst_n,
	in_address,
	out_address
    );

input clk, rst_n;
input [31:0] in_address;
output reg [31:0] out_address; 

//here the code will run whenever value of clk or rst_n change. 
always @ (posedge clk or negedge rst_n) //posedge - 0 to 1 and negedge - 1 to 0
begin
  if(!rst_n)
  out_address <= 32'd0; //initialize out_address with 0 with size 32.
  else
  out_address <= in_address; //initialize out_address with in_address instead.
end

endmodule