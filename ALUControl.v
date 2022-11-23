module ALUControl( ALU_Control, ALUOp, Function);  
    output reg[2:0] ALU_Control;  
    input [1:0] ALUOp;  
    input [3:0] Function;  
    wire [5:0] ALUControlIn;  
    assign ALUControlIn = {ALUOp,Function};  
    always @(ALUControlIn)  
    casex (ALUControlIn)  

//left most bits are the ALU OP, the four bits are the function field 
        6'b00xxxx: ALU_Control=3'b010;  //ALUControlIn == 0010, compute add ALU action with LW and SW instructions
        6'b01xxxx: ALU_Control=3'b110;  //ALUControlIn == 0110, compute sub ALU action with Branch equal instruction
        6'b100000: ALU_Control=3'b010;  //ALUControlIn == 0010, compute sub ALU action with BEQ instuction
        6'b100010: ALU_Control=3'b110;  //ALUControlIn == 0110, compute sub ALU action with R-type
        6'b100100: ALU_Control=3'b000;  //ALUControlIn == 0000, compute AND ALU action with R-type 
        6'b100101: ALU_Control=3'b001;  //ALUControlIn == 0001, compute OR ALU action with R-type
        6'b101010: ALU_Control=3'b111;  //ALUControlIn == 0111, compute set on less than ALU action with R-type
        default: ALU_Control=3'b000;    
    endcase  
 endmodule  

module JR_Control( input[1:0] alu_op, 
       input [3:0] funct,
       output JRControl
    );
assign JRControl = ({alu_op,funct}==6'b001000) ? 1'b1 : 1'b0;
endmodule