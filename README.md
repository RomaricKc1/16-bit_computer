# 16-bit_computer

```16-bit machine``` on [Logisim](https://github.com/logisim-evolution/logisim-evolution)

To program : 
Generate the machine code using tool provided from by this repo: [Customasm](https://github.com/hlorenzi/customasm) on this webpage [machine code](https://hlorenzi.github.io/customasm/web/).
Remove default program and paste the content of [assembler](assembler/customasm.asm) there.
You can then modify the application using simple ```mnemonics```.

Select LogiSim 16-bit and hit the assemble to generate the machine code. This hex conten, then goes to the ```CPU``` RAM memory.

Example of an application that runs on the CPU:
```
; example

foo:
	.org:
		ldi 0x03
		ldii 0x09
		ssp 0xfd
		push r0
		push r0
		push r1
		bl .mult_plus_one
		pop r0
		pop r0
		pop r0
		sta 0x41
		mout 0x41
		jump .end
		
	.mult_plus_one:
		peek 0x02, r0
		ldii 0x01
		add r0, r1
		peek 0x1, r1
		add r0, r1
		poke 0x03, r0
		ret
		
	.end:
		nop
		jump .end
		
```

Annotation from CustomAsm

```
 outp | addr | data

  0:0 |    0 |       ; foo:
  0:0 |    0 |       ; .org:
  0:0 |    0 | c0 03 ; ldi 0x03
  2:0 |    1 | c8 09 ; ldii 0x09
  4:0 |    2 | e0 fd ; ssp 0xfd
  6:0 |    3 | 38 00 ; push r0
  8:0 |    4 | 38 00 ; push r0
  a:0 |    5 | 38 01 ; push r1
  c:0 |    6 | f0 0d ; bl .mult_plus_one
  e:0 |    7 | 40 00 ; pop r0
 10:0 |    8 | 40 00 ; pop r0
 12:0 |    9 | 40 00 ; pop r0
 14:0 |    a | 68 41 ; sta 0x41
 16:0 |    b | d0 41 ; mout 0x41
 18:0 |    c | a8 14 ; jump .end
 1a:0 |    d |       ; .mult_plus_one:
 1a:0 |    d | 98 20 ; peek 0x02, r0
 1c:0 |    e | c8 01 ; ldii 0x01
 1e:0 |    f | 48 01 ; add r0, r1
 20:0 |   10 | 98 11 ; peek 0x1, r1
 22:0 |   11 | 48 01 ; add r0, r1
 24:0 |   12 | a0 30 ; poke 0x03, r0
 26:0 |   13 | e8 00 ; ret
 28:0 |   14 |       ; .end:
 28:0 |   14 | f8 00 ; nop
 2a:0 |   15 | a8 14 ; jump .end
```
The example above simple use routine to add to the sum of two numbers, 1, and display it to the segment display.

Example using the LCD screen: Displays ```HELLO```


Annoted assembly:
```
 outp | addr | data

  0:0 |    0 |       ; foo:
  0:0 |    0 |       ; .org:
  0:0 |    0 | c0 48 ; ldi "H"
  2:0 |    1 | c8 45 ; ldii "E"
  4:0 |    2 | 68 f0 ; sta 0xf0
  6:0 |    3 | 70 f1 ; stb 0xf1
  8:0 |    4 | c0 4c ; ldi "L"
  a:0 |    5 | c8 4f ; ldii "O"
  c:0 |    6 | 68 f2 ; sta 0xf2
  e:0 |    7 | 68 f3 ; sta 0xf3
 10:0 |    8 | 70 f4 ; stb 0xf4
 12:0 |    9 | 90 00 ; curs 0x0, 0x0
 14:0 |    a | 30 f0 ; disp 0xf0
 16:0 |    b | 90 08 ; curs 0x1, 0x0
 18:0 |    c | 30 f1 ; disp 0xf1
 1a:0 |    d | 90 10 ; curs 0x2, 0x0
 1c:0 |    e | 30 f2 ; disp 0xf2
 1e:0 |    f | 90 18 ; curs 0x3, 0x0
 20:0 |   10 | 30 f3 ; disp 0xf3
 22:0 |   11 | 90 20 ; curs 0x4, 0x0
 24:0 |   12 | 30 f4 ; disp 0xf4
 26:0 |   13 | a8 14 ; jump .nowhere
 28:0 |   14 |       ; .nowhere:
 28:0 |   14 | f8 00 ; nop
 2a:0 |   15 | a8 14 ; jump .nowhere
```

# REGISTERS

5 general purpose registers for quick storage and computation. Arithmetic operations are possible between registers and also the copy of one register value into an another is possible.
```
r0, r1, r2, r3, r4
```
Routines management

To ease the programming through functions, the ```stack``` allows to store the function input parameters, variables that the function might need to create in order to perform certain tasks. The result can be written into any register thanks to the ability to ```pop/poke``` into any of the 5 registers available.


The Link register eases the return from a routine. Since it holds the return address, there is no need to manually push the return address onto the stack.

```
SP, LR
```
Status register

The PSR allows us to have the status of previous the arithmetic computation. It stores the Carry flag and the zero flag which are raised if the last operation result has a Carry or if the result is zero respectively. This eases some conditional computation.

```
PSR
```

# ALU
```
Made of 1 full 16-bit [adder, Multiplier, Divider

Status: Carry, Zero
```


# MEMORY
## ROM
```
This is a look-up table were every combinaison of the instructions are stored.
11 bits address, 16 bits data width
```

## RAM
```
The location for the program, the stack and the variable location.
16 bits address, 16 bits data width
```

# DISPLAY
```128 x 64``` dot display using monochrome 4-bit as color. This makes up to a LCD with aspect ration ```21:7``` with hardware set cursor method.

Displays a content of RAM. 

To display a ```letter``` simply put the ASCII code of the char. 

To display a number say ```0x07``` (in ```Hex```) to the LCD, some specific function have to be used to ```convert``` the ```Hex``` to ```Dec``` and display the specific decimal char.

eg: (hex into base 10) 7/10 = 0 ```remainder```  7 -> 7 gets displayed

   (dec into base 10) 27/10 = 2 ```remainder``` 7 -> 7 displayed (decreasing position)
  
   2/10  = 0 ```remainder``` 2 -> 2 displayed 





# ISA
16 bits : 5 for the intruction opcode and 11 for the instruction address
```
0 0000   000 0000 0000
|  OP |  |  ADDRESS  |
```
## STORE OPERATIONS (6)

```
Address KKK KKKK KKKK : 11 bits
```
| Mnemonic | opcode [15-11]| operand [10-8] | operand [7-4] | operand [3-0] | comment |
| ------ | ------- | ------ | ------ | ------ | ------ |
| STA | 01101 | KKK | KKKK | KKKK | Store content of register ```r0``` into memory at specified address K |
| STB | 01110 | KKK | KKKK | KKKK | Store content of register ```r1``` into memory at specified address K |
| STC | 01111 | KKK | KKKK | KKKK | Store content of register ```r2``` into memory at specified address K |
| STD | 10000 | KKK | KKKK | KKKK | Store content of register ```r3``` into memory at specified address K |
| STE | 10001 | KKK | KKKK | KKKK | Store content of register ```r4``` into memory at specified address K |


## LOAD OPERATIONS (8)
```
Address KKK KKKK KKKK : 11 bits
Literal LLL LLLL LLLL : 11 bits (0 - 2046)
```
| Mnemonic | opcode [15-11]| operand [10-8] | operand [7-4] | operand [3-0] | comment |
| ------ | ------- | ------ | ------ | ------ | ------ |
| LDA  | 00001 | KKK | KKKK | KKKK | Load register ```r0``` with memory content at specified address K |
| LDB  | 00010 | KKK | KKKK | KKKK | Load register ```r1``` with memory content at specified address K |
| LDC  | 00011 | KKK | KKKK | KKKK | Load register ```r2``` with memory content at specified address K |
| LDD  | 00100 | KKK | KKKK | KKKK | Load register ```r3``` with memory content at specified address K |
| LDE  | 00101 | KKK | KKKK | KKKK | Load register ```r4``` with memory content at specified address K |
| LDI  | 11000 | LLL | LLLL | LLLL | Load register ```r0``` with literal L |
| LDII | 11001 | LLL | LLLL | LLLL | Load register ```r1``` with literal L |


## ARITHMETICS OPERATIONS (4)
```
Register source     : rs rs rs rs
Register detination : rd rd rd rd
```
| Mnemonic | opcode [15-11]| operand [10-8] | operand [7-4] | operand [3-0] | comment |
| ------ | ------- | ------ | ------ | ------ | ------ |
| ADD  | 01001 | --- | rd rd rd rd | rs rs rs rs | Add register ```rd``` to register ```rs``` and store the result into ```rd``` |
| SUB  | 01010 | --- | rd rd rd rd | rs rs rs rs | Substract register ```rd``` to register ```rs``` and store the result into ```rd``` |
| MULT | 01011 | --- | rd rd rd rd | rs rs rs rs | Multiply register ```rd``` by register ```rs``` and store the result into ```rd``` |
| DIV  | 01100 | --- | rd rd rd rd | rs rs rs rs | Divide register ```rd``` by register ```rs``` and store the result into ```rd``` |




## CONTROL FLOW (3)
```
Jump to address : KKK KKKK KKKK (11 bits RAM address)
```
| Mnemonic | opcode [15-11]| operand [10-8] | operand [7-4] | operand [3-0] | comment |
| ------ | ------- | ------ | ------ | ------ | ------ |
| JUMP  | 10101 | KKK | KKKK | KKKK | Jump to instruction at address ```K```|
| JUMPC | 10110 | KKK | KKKK | KKKK | Jump to instruction at address ```K``` if the last arithmetic operation set the ```C```flag|
| JUMPZ | 10111 | KKK | KKKK | KKKK | Jump to instruction at address ```K``` if the last arithmetic operation set the ```Z```flag|



## ROUTINES (7)
```
Register source       : rs rs rs rs
Register detination   : rd rd rd rd
Literal LLL LLLL LLLL : 11 bits (0 - 2046)
Literal LLLL          : 4 bits (0 - 15)
Jump to address       : KKK KKKK KKKK (11 bits RAM address)
```
| Mnemonic | opcode [15-11]| operand [10-8] | operand [7-4] | operand [3-0] | comment |
| ------ | ------- | ------ | ------ | ------ | ------ |
| PUSH | 00111 | --- | ---- | rs rs rs rs | Push register ```rs``` value into stack at address SP |
| POP  | 01000 | --- | ---- | rd rd rd rd | POP  stack and save into register ```rd``` |
| POKE | 10100 | --- | LLLL | rs rs rs rs | Put register ```rs``` content into stack at address ```SP + L`` and SP unchanged |
| PEEK | 10011 | --- | LLLL | rd rd rd rd | Save into register ```rd``` the content of stack at address ```SP + L``` and SP unchanged |
| SSP  | 11100 | LLL | LLLL | LLLL | Load into ```SP``` register the literal L |
| BL   | 11110 | KKK | KKKK | KKKK | Branch program to routine at specified address |
| RET  | 11101 | --- | ---- | ---- | Return at Main program from inside a routine |




## MISC (3)
```
Register source     : rs rs rs rs
Register detination : rd rd rd rd
Address             : KKK KKKK KKKK (11 bits RAM address)
Cursor Position     : x: L (5 bits), y: l (3 bits)
```
| Mnemonic | opcode [15-11]| operand [10-8] | operand [7-4] | operand [3-0] | comment |
| ------ | ------- | ------ | ------ | ------ | ------ |
| MOUT | 11010 | KKK | KKKK | KKKK | Display (7-segment) the memory content at specified address K |
| MOV  | 11011 | --- | rd rd rd rd | rs rs rs rs | Move register ```rs``` content into register ```rd``` |
| NOP  | 11111 | --- | ---- | ---- | Nop instruction. CPU does nothing |
| CURS  | 10010 | --- | LLLL | Llll | Set LCD cursor to ```(x=L, y=l)``` |
| DISP  | 00110 | KKK | KKKK | KKKK | Display to the LCD screen, the memory content at specified address K |


