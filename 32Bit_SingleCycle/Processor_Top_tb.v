module Processor_Top_tb;

// Inputs
reg clk;
reg rst_n;

// Instantiate the Unit Under Test (UUT)
Processor_Top uut (
	.clk(clk), 
	.rst_n(rst_n)
);

always #5 clk = ~clk;

initial begin
    
	$dumpfile("processor.vcd");
	$dumpvars();

	clk = 1'b1;
	rst_n = 1'b0;
	#30
	rst_n = 1'b1;
	#100	
	$finish;
end
      
endmodule