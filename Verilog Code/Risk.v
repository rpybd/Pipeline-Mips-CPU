`include "ctrl_encode_def.v"
module Risk( IDEXMemR, rs, rt, CtrlFlush, IFIDWr,
				NPCOp, RtdtoEX, RtdtoWB, RegWB, 
				EXMEMemR, MEMWBMemR, IDEXRFWr, EXMEMRFWr,
				RD1, RD2, AluC, WD, IFlush );
//for beq and lw
	input        IDEXMemR, EXMEMemR, MEMWBMemR;
	input        IDEXRFWr, EXMEMRFWr;
	input [4:0]  RtdtoEX, RtdtoWB, RegWB;
	input [1:0]  NPCOp;
	input [31:0] AluC, WD;
	input [4:0]  rs, rt;
	input [31:0] RD1, RD2;
	output reg   CtrlFlush;
	output reg   IFIDWr;
	output reg   IFlush;

	reg [31:0] tempRD1, tempRD2;
	always @(*) begin
	  CtrlFlush = 0;
		IFIDWr = 1;
	  IFlush = 0;
		if( IDEXMemR && 
			(RtdtoEX == rs || RtdtoEX == rt) && NPCOp != `NPC_BRANCH) begin
			CtrlFlush = 1;
			IFIDWr = 0;
		end//end lw

		if( NPCOp == `NPC_BRANCH ) begin
			tempRD1 = RD1;
			tempRD2 = RD2;
			CtrlFlush = 0;
			IFIDWr = 1;
			//nop
			if( !IDEXMemR ) begin//lw 2 step || r step
				if( (RtdtoWB == rs || RtdtoWB == rt) && EXMEMemR ) begin//lw 2 step
				  CtrlFlush = 1;
				  IFIDWr = 0;
				end
				else if( (RtdtoEX == rs || RtdtoEX == rt) && IDEXRFWr ) begin//r step
				  CtrlFlush = 1;
				  IFIDWr = 0;
				end
			end
			else if( IDEXMemR &&     // lw 1 step nop
					(RtdtoEX == rs || RtdtoEX == rt) ) begin
				CtrlFlush = 1;
				IFIDWr = 0;
			end
			//forward
			if( (RegWB == rs || RegWB == rt) && MEMWBMemR ) begin//lw 2 step
					if(RegWB == rs)
						tempRD1 = WD;
					else
						tempRD2 = WD;
				end
				else if( (RtdtoWB == rs || RtdtoWB == rt) && EXMEMRFWr ) begin//r step
					if(RtdtoWB == rs)
						tempRD1 = AluC;
					else
						tempRD2 = AluC;
			end 
			IFlush = (tempRD1 == tempRD2) ? 1 : 0;
		end//end branch
		if( NPCOp == `NPC_JUMP || NPCOp == `NPC_JR ) begin
	    CtrlFlush = 1;
		  IFlush = 1;//jump and jr
		end
	end//end always
endmodule
