/*	Ctrl Stream
	format(27)
		MemR rsR rtR RFWr DMWr Sw EXTOp ALUOp NPCOp SpeRegAddr RegDst ALUSrcA ALUSrcB MemtoReg
		26   25  24  23   22   21 20:19 18:14 13:12 11:7       6:5    4:3     2:1     0
		0    0   0   0	   0	   0  00    00000 00    00000      00     00      00      0
*/
// `define Ctrl_ADDU 27'b 0 1 1 1 0 0 00 00001 00 00000 01 00 00 0
// `define Ctrl_SUBU 27'b 0 1 1 1 0 0 00 00011 00 00000 01 00 00 0
// `define Ctrl_SLL  27'b 0 0 1 1 0 0 00 10001 00 00000 01 01 00 0
// `define Ctrl_SRL  27'b 0 0 1 1 0 0 00 10010 00 00000 01 01 01 0
// `define Ctrl_SRA  27'b 0 0 1 1 0 0 00 10011 00 00000 01 01 01 0
// `define Ctrl_ORI  27'b 0 1 0 1 0 0 01 00110 00 00000 00 00 01 0
// `define Ctrl_LUI  27'b 0 0 0 1 0 0 10 00000 00 00000 00 00 01 0
// `define Ctrl_LW   27'b 1 1 0 1 0 0 00 00010 00 00000 00 00 01 1
// `define Ctrl_SW   27'b 0 1 1 0 1 0 00 00010 00 00000 00 00 01 0
// `define Ctrl_BEQ  27'b 0 1 1 0 0 1 00 01011 01 00000 00 00 00 0
// `define Ctrl_J    27'b 0 0 0 0 0 1 00 00000 10 00000 00 00 00 0
// `define Ctrl_JAL  27'b 0 0 0 1 0 1 00 00001 10 11111 10 10 10 0
// `define Ctrl_JR   27'b 0 1 0 0 0 1 00 00000 11 00000 00 00 00 0
`define Ctrl_ADDU 27'b0_1_1_1_0_0_00_00001_00_00000_01_00_00_0
`define Ctrl_SUBU 27'b0_1_1_1_0_0_00_00011_00_00000_01_00_00_0
`define Ctrl_SLL  27'b0_0_1_1_0_0_00_10001_00_00000_01_01_00_0
`define Ctrl_SRL  27'b0_0_1_1_0_0_00_10010_00_00000_01_01_00_0
`define Ctrl_SRA  27'b0_0_1_1_0_0_00_10011_00_00000_01_01_00_0
`define Ctrl_ORI  27'b0_1_0_1_0_0_00_00110_00_00000_00_00_01_0
`define Ctrl_LUI  27'b0_0_0_1_0_0_10_00000_00_00000_00_00_01_0
`define Ctrl_LW   27'b1_1_0_1_0_0_00_00010_00_00000_00_00_01_1
`define Ctrl_SW   27'b0_1_1_0_1_1_00_00010_00_00000_00_00_01_0
`define Ctrl_BEQ  27'b0_1_1_0_0_0_00_01011_01_00000_00_00_00_0
`define Ctrl_J    27'b0_0_0_0_0_0_00_00000_10_00000_00_00_00_0
`define Ctrl_JAL  27'b0_0_0_1_0_0_00_00001_10_11111_10_10_10_0
`define Ctrl_JR   27'b0_1_0_0_0_0_00_00000_11_00000_00_00_00_0

// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10  
`define NPC_JR      2'b11

// EXT control signal
`define EXT_ZERO    2'b00
`define EXT_SIGNED  2'b01
`define EXT_HIGHPOS 2'b10

// ALU control signal
`define ALUOp_NOP   5'b00000 
`define ALUOp_ADDU  5'b00001
`define ALUOp_ADD   5'b00010
`define ALUOp_SUBU  5'b00011
`define ALUOp_SUB   5'b00100 
`define ALUOp_AND   5'b00101
`define ALUOp_OR    5'b00110
`define ALUOp_NOR   5'b00111
`define ALUOp_XOR   5'b01000
`define ALUOp_SLT   5'b01001
`define ALUOp_SLTU  5'b01010 
`define ALUOp_EQL   5'b01011
`define ALUOp_BNE   5'b01100
`define ALUOp_GT0   5'b01101
`define ALUOp_GE0   5'b01110
`define ALUOp_LT0   5'b01111
`define ALUOp_LE0   5'b10000
`define ALUOp_SLL   5'b10001
`define ALUOp_SRL   5'b10010
`define ALUOp_SRA   5'b10011

// GPR control signal
`define GPRSel_RD   2'b00
`define GPRSel_RT   2'b01
`define GPRSel_31   2'b10

`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC  2'b10 

// Memory control signal
`define BE_SB  2'b00
`define BE_SH  2'b01
`define BE_SW  2'b10

`define ME_LB  3'b000
`define ME_LBU 3'b001
`define ME_LH  3'b010
`define ME_LHU 3'b011
`define ME_LW  3'b100
