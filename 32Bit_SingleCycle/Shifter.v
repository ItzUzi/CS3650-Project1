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

assign outdata = shift_left ? indata<<shift_amt : indata>>shift_amt;

endmodule