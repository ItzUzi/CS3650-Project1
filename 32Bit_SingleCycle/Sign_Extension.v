module Sign_Extension(
	bits16_in,
	bits32_out
    );

input [15:0] bits16_in;  //  16 bits value goes in
output wire [31:0] bits32_out;  // 32 bit value goes out, not these values are the same


/*16 bit offset is sign extended to 32 bits */
assign bits32_out = {{16{bits16_in[15]}} , bits16_in[15:0]};

endmodule