module PipeLineMips( clk, rst);
	input clk, rst;

	//address stream
	wire [29:0] PC;         		//PC to IFID, IM[9:0]: address of instructions
	wire [29:0] NPC;        		//NPC to nextPC
	wire [29:0] PCIFID;				//IFID to NPC 
	//instruction stream
	wire [5:0]  Op;					//IFID to ctrl: instrID
	wire [5:0]  Funct;				//IFID to ctrl: instrID
	wire [4:0]  rs, rt, rd;			//IFID to ctrl: instrID
	wire [4:0]  rsEX, rtEX, rdEX;	//IDEX to RegDst_MUX: instrEX
	wire [31:0] AluA, AluB, AluC;	//ALUSrc_MUX to ALU
	wire [4:0]  RegWB;				//reg write address, MEMWB to RF
	wire [31:0] instrIF, instrID, instrEX;	//instr use in: IF, ID, EX
	//data stream
	wire [15:0] Imm16;				//immediate num16: instrID	
	wire [31:0] Imm32;				//immediateEXT num32: EXT to IDEX
	wire [25:0] IMM;				//to NPC: instrID				
	wire [31:0] WD;					//MemtoReg_MUX to RF
	wire [31:0] RD1, RD2;			//RF to IDEX
	wire [31:0] ExtraRD; //rt to Mem
	wire [31:0] SwRt; //rt to EXMEM
	wire [4:0]  RtdtoEX;			//RegDst_MUX to EXMEM
	wire [4:0]  RtdtoWB;			//EXMEM to MEMWB
	wire [31:0] AluARF, AluBRF;		//RF to IDEX: one of alu's opdata 		
	wire [31:0] Dout;				//DM to WB
	wire [31:0] DouttoMUX; //MEMWB to MUX
	wire [4:0]  MemAddr;			//EXMEM to DM
	wire [31:0] AluCFromReg;		//EXMEM to DM(addr), MEMWB, ALUSrc_MUX
	wire [31:0] MemData;			//EXMEM to DM(data)	
	wire [31:0] AluCtoMUX;
	//from Ctrl
	wire [1:0]  EXTOp;
	wire [1:0]  NPCOp;	
	wire 		     CtrlStr;			//ctrl to CtrlStream_MUX
	wire [26:0] Ctrl;				//mux to IDEX
	wire [26:0] CtrlStream;  //ctrl to mux
	wire [4:0]  SpeRegAddr;			//ctrl to RF

	wire        IFlush;  //risk to IFID
	wire        LWWr;  //IFID write enable
	wire [4:0]  ALUOp;				//IDEX to ALU
	wire [1:0]  RegDst;				//IDEX to RegDst_MUX
	wire [1:0]  ALUSrcA, ALUSrcB;	//IDEX to ALUSrc_MUX
	wire 		     DMWr;				//EXMEM to DM
	wire        RFWrEXMEM; //EXMEME to DataRisk
	wire 		     RFWr;				//MEMWB to RF
	wire        MemtoReg;			//MEMWB to MemtoReg
	wire [26:0] CtrlWBtoM, CtrlMtoM;	//IDEX to EXMEM
	wire [26:0] CtrlWBtoWB;			//EXMEM to MEMWB
	wire [1:0]  MemDataSrc; //sw: whether forward
	wire        MEMWBMemR;

	//use in ID stage
	assign Imm16 = instrID[15:0];
	assign IMM = instrID[25:0];
	assign Op = instrID[31:26];
	assign Funct = instrID[5:0];
	assign rs = instrID[25:21];
	assign rt = instrID[20:16];
	assign rd = instrID[15:11];
	//use in EX stage
	assign rsEX = instrEX[25:21];
	assign rtEX = instrEX[20:16];
	assign rdEX = instrEX[15:11];


	//IF stage
	PC P_PC (
		.clk(clk), .rst(rst), .NPC(NPC), .PC(PC)
	);
	IM P_IM (
		.addr(PC[9:0]), .dout(instrIF)
	);
	//ID stage
	IFID P_IFID (
		.rst(rst), .clk(clk), .PCIn(PC), .instrIFIDIn(instrIF), 
		.PCOut(PCIFID), .instrIFIDOut(instrID), .Wr(LWWr), .IFlush(IFlush)
	);
	NPC P_NPC (	
		.rst(rst), .PC(PC), .NPCOp(NPCOp), .IMM(IMM), .RA(RD1), .NPC(NPC), .Wr(LWWr), .IFlush(IFlush)
	);
	RF P_RF (
		.A1(rs), .A2(rt), .A3(RegWB), .WD(WD), .clk(clk), 
		.RFWr(RFWr), .RD1(RD1), .RD2(RD2), .SpeRegAddr(SpeRegAddr), .PC4JAL(PCIFID)
	);
	Ctrl P_Ctrl (
		.Op(Op), .Funct(Funct), 
		.CtrlStream(CtrlStream), .EXTOp(EXTOp), .NPCOp(NPCOp), .SpeRegAddr(SpeRegAddr)
	);
	Risk P_Risk (
	  .IDEXMemR(CtrlMtoM[26]), .rs(rs), .rt(rt), .IFIDWr(LWWr),
	  .NPCOp(NPCOp), .RtdtoEX(RtdtoEX), .RtdtoWB(RtdtoWB), .RegWB(RegWB),
	  .EXMEMemR(CtrlWBtoWB[26]), .MEMWBMemR(MEMWBMemR), .IDEXRFWr(CtrlMtoM[23]), .EXMEMRFWr(CtrlWBtoWB[23]), 
	  .RD1(RD1), .RD2(RD2), .AluC(AluCFromReg), .WD(WD), 
	  .CtrlFlush(CtrlStr), .IFlush(IFlush)
	);
	mux2 #(.WIDTH(27)) CtrlStr_MUX2(
		.d0(CtrlStream), .d1(27'd0), .s(CtrlStr), .y(Ctrl)
	);
	EXT P_EXT ( 
		.Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 	
	);
	//EX stage
	IDEX P_IDEX (
		.rst(rst), .clk(clk), .CtrlStream(Ctrl), .RD1In(RD1), .RD2In(RD2), .EXTIn(Imm32), 
		.instrIDEXIn(instrID), .AluARF(AluARF), .AluBRF(AluBRF), .instrIDEXOut(instrEX),
		.NCtrlWB(CtrlWBtoM), .NCtrlM(CtrlMtoM), .RegDst(RegDst), .ALUOp(ALUOp), .SwRt(SwRt)
	);
	mux4 #(.WIDTH(32)) ALUSrcA_MUX4(
		.d0(AluARF), .d1(AluCFromReg), .d2(WD), .d3(0), .s(ALUSrcA), .y(AluA)
	);
	mux4 #(.WIDTH(32)) ALUSrcB_MUX4(
		.d0(AluBRF), .d1(AluCFromReg), .d2(WD), .d3(0), .s(ALUSrcB), .y(AluB)
	);
	mux4 #(.WIDTH(5)) RegDst_MUX4(
		.d0(rtEX), .d1(rdEX), .d2(5'b11111), .d3(5'b00000), .s(RegDst), .y(RtdtoEX)
	);
	ALU P_ALU (
		.A(AluA), .B(AluB), .ALUOp(ALUOp), .C(AluC)
	);
	DataForward P_DataForward (
		.EXMEMRFWr(RFWrEXMEM), .MEMWBRFWr(RFWr), .IDEXRs(rsEX), .IDEXRt(rtEX), 
		.EXMEMRtd(RtdtoWB), .MEMWBRtd(RegWB), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), 
		.rsR(CtrlWBtoM[25]), .rtR(CtrlWBtoM[24]), .MemDataSrc(MemDataSrc), .sw(CtrlWBtoM[21])
	);
	//MEM stage
	EXMEM P_EXMEM (
		.rst(rst), .clk(clk), .CtrlWB(CtrlWBtoM), .CtrlM(CtrlMtoM), .NCtrlWB(CtrlWBtoWB), .MemDataSrc(MemDataSrc),
		.AluCEXMEMIn(AluC), .RtdEXMEMIn(RtdtoEX), .ExtraRD(MemData), 
		.AluCEXMEMOut(AluCFromReg), .RtdEXMEMOut(RtdtoWB), .DMWr(DMWr), .RFWrEXMEM(RFWrEXMEM),
		.SwForwardMem(WD), .SwForwardRf(SwRt), .SwForwardAlu(AluCFromReg)
	);
	DM P_DM (
		.clk(clk), .addr(AluCFromReg[11:2]), .din(MemData), .DMWr(DMWr), .dout(Dout)
	);
	//WB stage
	MEMWB P_MEMWB (
		.rst(rst), .clk(clk), .CtrlWB(CtrlWBtoWB), 
		.DmMEMWBIn(Dout), .AluCMEMWBIn(AluCFromReg),
		.RtdMEMWBIn(RtdtoWB), .DmMEMWBOut(DouttoMUX), .AluMEMWBOut(AluCtoMUX),
		.RtdMEMWBOut(RegWB), .RFWr(RFWr), .MemtoReg(MemtoReg), .MEMWBMemR(MEMWBMemR)
	);
	mux2 #(.WIDTH(32)) MemtoReg_MUX2 (
		.d0(AluCtoMUX), .d1(DouttoMUX), .s(MemtoReg), .y(WD)
	);
endmodule

