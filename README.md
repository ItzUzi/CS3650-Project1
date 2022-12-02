# CS3650-Project1

We have put notes BOTH in the code (as comments) and in the readme to demonstrate our understanding of the code. 

https://electrobinary.blogspot.com/2021/02/mips-processor-design-using-verilog-part1.html?m=1

## Alu_Control.v

This file grabs the 6 bit opcode and 6 bit function field as inputs from the 32 bit MIPS instruction, and outputs the ALU control input based on the inputs. Since function fields are only for R-type instructions, all the R-type instruction opcodes are (000000)<sub>2</sub> and correlate to the function field. As for the I-type instructions (LW, SW, BEQ) their ALU control input is based on the opcode rather than the function code. This is because I-type (and J-type) instructions do not have a function field. The ALU control inputs, function fields, and 2 bit ALUOp listed in the code are based off the zybooks table: 

![image](https://user-images.githubusercontent.com/73093864/205182599-0f762713-963d-441d-90b2-b4a1c54eab20.png)

## Alu_Core.v

This file takes in the 2 operands and the ALU control input (which will be fed into the ALU multiplexor as the operation selection) and outputs the result of the operation. These operations are add, subtract, AND, OR, NOR, and SLT.

## Alu_Top.v

(NOTE: A top-level module contains all relevant modules) The file combines both the Alu_Control and the Alu_Core modules, which reflects the diagram below.

![image](https://user-images.githubusercontent.com/73093864/205184230-14323199-955e-4493-96fb-6142063bae4b.png)

## Sign_Extension.v

This file takes in the 16 bit offset value and sign extends it to a 32 bit value. This is used for I-type instructions (LW, SW, BEQ). This file reflects the diagram below.

![image](https://user-images.githubusercontent.com/73093864/205186942-f88f224c-4231-447e-8d96-53270d88a0c4.png)





