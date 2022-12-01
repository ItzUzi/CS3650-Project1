module Shifter(
	indata,
	shift_amt,
	shift_left,
	outdata
    );

input [31:0] indata;
input [1:0] shift_amt;
input shift_left;
output wire [31:0] outdata;

/* Used for BEQ instruction; if true, branch to the instruction
*  with the address equal to the next instruction address + 16 bit offset shifted left by 2 bits
*
* If BEQ is false, continue to next instruction in PC 
*/

assign outdata = shift_left ? indata<<shift_amt : indata>>shift_amt;

endmodule