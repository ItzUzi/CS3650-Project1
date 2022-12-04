# CS3650-Project1

We have put notes BOTH in the code (as comments) and in the readme to demonstrate our understanding of the code. Below, you will find a description of what each file does, and the role it plays in the MIPS datapath. The picture included will show where that file is being illustrated in the datapath. The task was to implement the single cycle processor described in zybooks chapter 4.4. The processor described in 4.4 handles only these instructions: LW, SW, BEQ, ADD, SUB, OR, AND, SLT.

"In this section, we look at what might be thought of as the simplest possible implementation of our MIPS subset. We build this simple implementation using the datapath of the last section and adding a simple control function. This simple implementation covers load word (lw), store word (sw), branch equal (beq), and the arithmetic-logical instructions add, sub, OR, and set on less than." -Zybooks chapter 4.4

https://electrobinary.blogspot.com/2021/02/mips-processor-design-using-verilog-part1.html?m=1

## Alu_Control.v

This file grabs the 6 bit opcode and 6 bit function field as inputs from the 32 bit MIPS instruction, and outputs the ALU control input based on the inputs. Since function fields are only for R-type instructions, all the R-type instruction opcodes are (000000)<sub>2</sub> and correlate to the function field. As for the I-type instructions (LW, SW, BEQ) their ALU control input is based on the opcode rather than the function code. This is because I-type (and J-type) instructions do not have a function field. The ALU control inputs, function fields, and 2 bit ALUOp listed in the code are based off the zybooks table: 

![image](https://user-images.githubusercontent.com/73093864/205182599-0f762713-963d-441d-90b2-b4a1c54eab20.png)

Following the table above we can see that each ALU operations along with function fields each make up different instruction operations. In order to utilize the ALU action, specific ALU inputs must used to get the desired action. 

## Alu_Core.v

This file takes in the 2 operands and the ALU control input (which will be fed into the ALU multiplexor as the operation selection) and outputs the result of the operation. These operations are add, subtract, AND, OR, NOR, and SLT. ALU control inputs for each operation: 0010, 0110, 0000, 0001, 0100, 0111 respectively. If an input was not given, the default operation will be the add ALU input.

## Alu_Top.v

(NOTE: A top-level module contains all relevant modules) The file instantiates and connects both the Alu_Control and the Alu_Core modules, which reflects the diagram below. This will in turn implement the ALU using the instuctions set in MIPS.

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

For example, in the picture below, notice that the operand A = 00002222 and operand B = 00001111. The function field is 20 and opcode 00 in hex, signifying to the ALU to ADD the 2 operands. Thus, the result variable output is 00003333, which is the correct sum of A+B. In another clock cycle, function field is 24 in hex, for the same operands and opcode, signifying to the ALU an AND operation. It should return a 1 in each bit position for which the corresponding bits of both operands are 1s. Thus, the result = 00000000. This is because 1 in hex is 0001 and 2 is 0010, so there will be no case where the bits both match as 1. Note that R-type instructions have an opcode of 0000000, so the input opcode does not equal this, the result will just be 00000000. In another clock cycle, the function field is 2A in hex for the same operands and opcode for the previous R-type instruction. This signifys a SLT operation. Since A < B, the result is 00000001, which is the correct result. In another clock cycle, the function field is 27 in hex, and the same operands and opcode. This signifies a NOR, so the result is FFFFCCCC, this is because the 1 in hex to binary is 0001 and 2 in hex in binary is 0010. The NOR is 1100, which is C. This is why the first half of the 32 bit result is C and the 2nd half is F because the NOR of 0000 and 0000 is 1111, which is F in hex. Thus, the NOR is verified. For the last clock cycle, function field 22 in hex represents a subtraction operation. A = 00002222 and B = 00001111. A - B = 00001111, which is the correct difference. Thus, all the ALU operations are verified to be correct.

![image](https://user-images.githubusercontent.com/89324119/205515466-6a1a02e8-564b-4a53-b587-e7be004f2c38.png)

These waves are meant to represent how the variables are read through MIPS since this time the variables are actually registers which are being read and overwritten with each opcode. We convert MIPS assembly language into its Hexadecimal format and use those files as input for these waves. Since these waves are meant to be the product of Registers instead of simple inputs, we used files to store values such as the MIPS instructions as hex, intial valuesin memory for sw and lw, and memory to be used for each register.

There are some notable things to point out in this picture. First, look at how the instrn_address is incrementing by 4 each clock cycle, which is expected, since PC+4. Also, at time stamp 0 sec, notice bits16_in is 5820 in hex, and bits32_out is 00005820, showing that we have sign extended the bits from 16 to 32. This worked as expected, which was great to see all the pieces moving in clockwork to make the processor function correctly. Now, take a look at 30 second timestamp. The first instruction stated in the instrn_memory.mem file is add $t1, $t2, $t3. In hex, this is 01 2A 58 20. After loading the instruction, we see that read_addr1 and read_addr2 holds the addresses of registers $t1 and $t2. Also, read_data1 and read_data2 hold the data in the registers, which is 00000001 and 00000002 respectively. These numbers are from the reg_memory.mem file. We can see the sum of these numbers located in result. Notice how write_en is 1 at this time, meaning that data must be written to the $t3 register.The write_data, which holds the result of the operation, will be saved to the $t3 regisers, where the write_addr holds the address of the register to be written. In conclusion, we just ran the add instruction in 1 cock cycle. The in_address is 00000004, because it is ready for the next instruction. The out_address shows us the current PC address that had ran the instruction. This is just one instruction, but it shows that we were successful in making the processor and being able to have a deep understanding of how all the compnenents work together to make one instruction execute, and many others that are to come.

![image](https://user-images.githubusercontent.com/89324119/205515300-fb23e6b2-c012-4e28-89d0-9b220d6e6a91.png)




