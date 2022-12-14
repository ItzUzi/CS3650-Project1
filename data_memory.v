 module data_memory  
 (  
    input clk,   //clock
    input [31:0] mem_access_addr,  
    input [31:0] mem_write_data,  
    input mem_write_en,  
    input mem_read,  

    output [31:0] mem_read_data  
 );  

/* This file is not used in the 32 bit single cycle or pipeline, but solely used for getting a deeper understanding of the mips datapath and verilog */

      integer i;  
      reg [31:0] ram [255:0];  // declares 256 element array at 16 bits wide each element
      wire [7 : 0] ram_addr = mem_access_addr[8 : 1];//wire   
      initial begin  
           for(i=0;i<256;i=i+1)  
                ram[i] <= 32'd0;  //initialize ram array elements to 0 with size 16.
      end  
      always @(posedge clk) begin  // runs if clock changes val from 0 -> 1 or 1 -> 0
           if (mem_write_en)        //if mem_write_en == 1 (in other words, is true)
                ram[ram_addr] <= mem_write_data;  // changes ram[ram_addr] to mem_write_data when clock changes and mem_write_en == 1
      end  
      /** determines whether or not to write data to memory*/
      assign mem_read_data = (mem_read==1'b1) ? ram[ram_addr]: 32'd0;   // Everytime mem_read changes, changes value of mem_read_data
 endmodule   