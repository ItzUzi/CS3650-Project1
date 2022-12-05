module Jump_Shifter(
	indata,
	shift_amt,
	shift_left,
	outdata
    );

input [25:0] indata;   //value before shift
input [1:0] shift_amt;  //amt to shift
input shift_left;      // if 1, shift, else, no shift
output wire [27:0] outdata;  //value after shift

/* 
*  
*
*
*/

assign outdata = shift_left ? indata<<shift_amt : indata>>shift_amt;

endmodule