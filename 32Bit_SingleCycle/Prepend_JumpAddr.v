module Prepend_JumpAddr(
    clk,
	indata,
    instrn_address
	ctrl_jump,
	outdata
    );

input [25:0] indata;   //value before shift
input [31:0] instrn_address;
input ctrl_jump;      // if 1, shift, else, no shift
output wire [31:0] outdata;  //value after shift

/* 
*  Concatenates bits 31-28 from PC address to 28 bit jump label, to make 32 bits
*
*
*/
always @ (posedge clk)  // every time clk goes from 0 to 1
begin
assign outdata = ctrl_jump ? {instrn_address[31:28], indata} : indata;  //concatenate bits
end
endmodule