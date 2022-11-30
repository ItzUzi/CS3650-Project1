module Instruction_Memory(
	instrn_address,
	instrn
    );//this module will focus on how to store instructions of a program

input [31:0] instrn_address; //5-bit address holds 8 instructions of 32-bit width
output wire [31:0] instrn; //output will be 32-bit width aswell. 
reg [7:0] instrn_mem [31:0];

initial begin
$readmemh("instrn_memory.mem", instrn_mem);	//using readmemh, we can load instruction memory from a mem file.
end

assign instrn = {instrn_mem[instrn_address+3],instrn_mem[instrn_address+2],	
                 instrn_mem[instrn_address+1],instrn_mem[instrn_address]};

endmodule