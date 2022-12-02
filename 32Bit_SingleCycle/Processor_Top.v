module Processor_Top(
	clk,
	rst_n
    );

input clk;
input rst_n;

wire [31:0] ctrl_in_address;
wire [31:0] out_address;
wire [31:0] addr_incr;
wire [31:0] address_plus_4;
wire [31:0] branch_addr_offset;
wire [31:0] branch_address;
wire [31:0] instrn;
wire ctrl_write_en;
wire final_write_en;
wire [4:0] ctrl_write_addr;
wire [31:0] ctrl_regwrite_data;
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] sign_ext_out;
wire [31:0] ctrl_aluin2;
wire [31:0] alu_result;
wire zero_out;
wire [31:0] datamem_read_data;

assign addr_incr = (!rst_n) ? 32'd0 : 32'd4;
assign final_write_en = (!rst_n) ? 1'b0 : ctrl_write_en;



endmodule