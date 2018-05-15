module EXMEM( clk, rst, CtrlWB, CtrlM, AluCEXMEMIn, RtdEXMEMIn, SwForwardMem, SwForwardRf, SwForwardAlu,
				AluCEXMEMOut, RtdEXMEMOut, NCtrlWB, RFWrEXMEM, DMWr, ExtraRD, MemDataSrc);
//ex\mem register, 5 inputs, 4 outputs
  input             clk, rst;
	input      [26:0] CtrlWB, CtrlM;
	input      [31:0] AluCEXMEMIn;
	input      [31:0] SwForwardMem, SwForwardRf, SwForwardAlu;
	input      [4:0]  RtdEXMEMIn;
	input      [1:0]  MemDataSrc;
	output reg [31:0] AluCEXMEMOut;
	output reg [4:0]  RtdEXMEMOut;
	output reg [26:0] NCtrlWB;
	output reg [31:0] ExtraRD;
	output            RFWrEXMEM, DMWr;

	always @(posedge rst) begin
		AluCEXMEMOut = 0;
		RtdEXMEMOut = 0;
		NCtrlWB = 0;
	end//end initial

	always @( posedge clk ) begin  
	 if( MemDataSrc == 2'b00 )
		  ExtraRD = SwForwardRf;
	 else if( MemDataSrc == 2'b01 )
		  ExtraRD = SwForwardAlu;
	 else if( MemDataSrc == 2'b10 )
		  ExtraRD = SwForwardMem;	
		AluCEXMEMOut <= AluCEXMEMIn;
		RtdEXMEMOut <= RtdEXMEMIn;	  
		NCtrlWB <= CtrlWB;
	end//end always

	assign RFWrEXMEM = NCtrlWB[23];
	assign DMWr = NCtrlWB[22];
endmodule
