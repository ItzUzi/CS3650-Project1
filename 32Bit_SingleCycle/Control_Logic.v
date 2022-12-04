module Control_Logic(
        instrn,
	instrn_opcode,
	address_plus_4,
	branch_address,
	ctrl_in_address,
	alu_result,
	zero_out,
	ctrl_write_en,
	ctrl_write_addr,
	read_data2,
	sign_ext_out,
	ctrl_aluin2,
	ctrl_datamem_write_en,
	datamem_read_data,
	ctrl_regwrite_data
    );

input [31:0] instrn;	 
input [5:0] instrn_opcode;
input [31:0] address_plus_4;
input [31:0] branch_address;
input [31:0] datamem_read_data;
input [31:0] alu_result;
input zero_out;
input [31:0] read_data2;
input [31:0] sign_ext_out;

output wire [31:0] ctrl_in_address;
output wire ctrl_write_en;
output wire [4:0] ctrl_write_addr;
output wire [31:0] ctrl_aluin2;
output wire ctrl_datamem_write_en;
output wire [31:0] ctrl_regwrite_data;

/*Select either branch address (for BEQ) or address+4 (for other cases) 
* Branches only if 2 operands equal
* BEQ opcode: 000100
*/
assign ctrl_in_address = (instrn_opcode==6'h04 && zero_out) ? branch_address : address_plus_4;

/*Write enable for regfile only for R-Type and LW instructions 
* R-type Opcode: 000000
* LW opcode: 100011
*/
assign ctrl_write_en = (instrn_opcode==6'h00) || (instrn_opcode==6'h23);

/*Write address for regfile selection based on R-Type and I-Type instructions 
* R-type Opcode: 000000
* If R-type, then get address of destination register in bits 15-11
* Else (I-type), then get address of destination register in bits 20-16
*/
assign ctrl_write_addr = (instrn_opcode==6'h00) ? instrn[15:11] : instrn[20:16];

/*Write data for regfile is from Data mem (LW) or from ALU 
* 
*/
assign ctrl_regwrite_data = (instrn_opcode==6'h23) ? datamem_read_data : alu_result;

/* Second input of ALU is either from regfile (R_Type) or sign ext unit (LW & SW) 
* R-type Opcode: 000000
* LW opcode: 100011
* SW opcode: 101011
* If R type or LW or SW, we must sign extend the offset
* Else, continue
*/
assign ctrl_aluin2 = (instrn_opcode==6'h23 || instrn_opcode==6'h2B) ? sign_ext_out : read_data2;

/* Write enable to datamem only for SW instruction 
* SW opcode: 101011
*/
assign ctrl_datamem_write_en = (instrn_opcode==6'h2B); 

endmodule