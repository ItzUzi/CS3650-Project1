# CS3650-Project1

We have put notes BOTH in the code (as comments) and in the readme to demonstrate our understanding of the code. Below, you will find a description of what each file does, and the role it plays in the MIPS datapath. The picture included will show where that file is being illustrated in the datapath. 

https://electrobinary.blogspot.com/2021/02/mips-processor-design-using-verilog-part1.html?m=1

## Alu_Control.v

This file grabs the 6 bit opcode and 6 bit function field as inputs from the 32 bit MIPS instruction, and outputs the ALU control input based on the inputs. Since function fields are only for R-type instructions, all the R-type instruction opcodes are (000000)<sub>2</sub> and correlate to the function field. As for the I-type instructions (LW, SW, BEQ) their ALU control input is based on the opcode rather than the function code. This is because I-type (and J-type) instructions do not have a function field. The ALU control inputs, function fields, and 2 bit ALUOp listed in the code are based off the zybooks table: 

![image](https://user-images.githubusercontent.com/73093864/205182599-0f762713-963d-441d-90b2-b4a1c54eab20.png)
Following the table above we can see that each ALU operations along with function fields each make up different instruction operations. In order to utilize the ALU action, specific ALU inputs must used to get the desired action. 
## Alu_Core.v

This file takes in the 2 operands and the ALU control input (which will be fed into the ALU multiplexor as the operation selection) and outputs the result of the operation. These operations are add, subtract, AND, OR, NOR, and SLT.

## Alu_Top.v

(NOTE: A top-level module contains all relevant modules) The file combines both the Alu_Control and the Alu_Core modules, which reflects the diagram below.

![image](https://user-images.githubusercontent.com/73093864/205184230-14323199-955e-4493-96fb-6142063bae4b.png)

## Sign_Extension.v

This file takes in the 16 bit offset value and sign extends it to a 32 bit value. This is used for I-type instructions (LW, SW, BEQ). This file reflects the diagram below.

![image](https://user-images.githubusercontent.com/73093864/205186942-f88f224c-4231-447e-8d96-53270d88a0c4.png)

## Control_Logic.v

This file contains the logic of the control unit. The input to the control unit is the 6-bit opcode field from the instruction. The outputs of the control unit consist of three 1-bit signals that are used to control multiplexors, three signals for controlling reads and writes in the register file and data memory, a 1-bit signal used in determining whether to possibly branch, and a 2-bit control signal for the ALU.
This is represented by the picture from zybooks below.

![image](https://user-images.githubusercontent.com/73093864/205467890-b870c2a3-5c00-4324-9f52-a798ae152ff2.png)

## Instruction_Memory.v

This file is used to store the instructions of a program. To execute any instruction, we must start by fetching the instruction from memory. Given an address, it goes to the instruction located at that address. We will be loading instruction memory using the readmemh function from a .mem file. 

## Program_Counter.v

This file is used for holding the address of the current instruction. To prepare for executing the next instruction, the program counter must be incrememnted by 4 bytes so that it points at the next instruction. Since instructions execute once every clock cycle, address incrememnts to the PC happen every clock cycle, which is why it is a D flip-flop. The picture below shows the fetching of an instruction and incrementation of the PC.

![image](https://user-images.githubusercontent.com/73093864/205469221-f46fd9c4-eef1-4b66-a3c0-6e81efe3ee42.png)

## Register_File.v

This file is used for reading and writing to registers. The register number inputs are 5 bits wide to specify one of 32 registers. We need at to read data from at most 2 register addresses (in the case of R-type), and write to 1 register address. Data input and two data output buses are each 32 bits wide, which is where we read the data from the register from.

![image](https://user-images.githubusercontent.com/73093864/205467962-ff8230c2-db2d-4b24-98c0-77ba406c012a.png)
![image](https://user-images.githubusercontent.com/73093864/205469616-b7156ad0-3941-43bc-962d-38ff93331f88.png)

## Data_Memory.v 

This file is used for reading and writing to memory, hence the name data memory. The data memory unit has read and write control signals, 2 inputs for the address and write data, and an output for the read result. There are separate read and write controls, but it is important to note that ONLY one of these may be asserted on any given clock cycle. 

![image](https://user-images.githubusercontent.com/73093864/205477380-23f16ed9-6699-4e44-a502-63e71d116aba.png)

## Shifter.v

This file is used for branching. If the condition did not pass, the address in the PC would just be incremented by 4. If the condition did pass, the ALU would then send a signal to the AND gate that allows the MUX the branch instruction uses to toggle, to signify that the condition passed. Since the condition passed, the PC needs to be loaded with the address the assembler assigned to the label in bits 15-0 in the instruction. When branching, the assembler just calculates the distance instruction wise, the branch needs to jump to get to the label's address. The 16 bit label is then sign extended to 32 bits, and shifted twice to convert our distance to bytes, since our address are byte-addressable. This number is then added to the incremented address of the current instruction, and is loaded into the PC.

![image](https://user-images.githubusercontent.com/73093864/205513442-205147be-010c-473c-a8ef-1e3692fff64b.png)


## Adder.v

This file simply takes in 2 inputs and outputs the sum of the 2 inputs. This is used when going to the next instruction, when doing PC + 4 or when branching to go to the label address. 

![image](https://user-images.githubusercontent.com/73093864/205517981-e649fadf-f452-4b46-88e5-ee441653e2f8.png)


## Processor_Top.v

This file contains the following modules: Program_Counter, Instruction_Memory, Register_File, Shifter, Alu_Top, Data_Memory, Control_Logic, and Adder to make the working 32 bit single cycle MIPS processor. The picture below encapsulates the processor we have created. 

![image](https://user-images.githubusercontent.com/73093864/205517876-4c9d614d-f55a-4c4d-8e45-fb418a2f656c.png)


## Interpreting the waves

These waves are meant to show what the results of different opcodes being used with 2 variables being A and B. Here we tested out a few opcodes being ADD, OR, NOR, AND, SW, and SLT, and the results were all verified to be working correctly. Both variables were used as input where then the Results would show under the result variable. These waves show that the logic was implemented correctly seeing as each result was the expected outcome. Each opcode and function field corresponded to the appropriate operations allowing the program to simulate the the inputs correctly.

For example, in the picture below, notice that the operand A = 00002222 and operand B = 00001111. The function field is 20 and opcode 00 in hex, signifying to the ALU to ADD the 2 operands. Thus, the result variable output is 00003333, which is the correct sum of A+B.

![image](https://user-images.githubusercontent.com/89324119/205515466-6a1a02e8-564b-4a53-b587-e7be004f2c38.png)

These waves are meant to represent how the variables are read through MIPS since this time the variables are actually registers which are being read and overwritten with each opcode. We convert MIPS assembly language into its Hexadecimal format and use those files as input for these waves. Since these waves are meant to be the product of Registers instead of simple inputs, we used files to store values such as the MIPS instructions as hex, intial valuesin memory for sw and lw, and memory to be used for each register.

![image](https://user-images.githubusercontent.com/89324119/205515300-fb23e6b2-c012-4e28-89d0-9b220d6e6a91.png)




