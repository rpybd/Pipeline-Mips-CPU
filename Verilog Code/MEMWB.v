module MEMWB( clk, rst, CtrlWB, DmMEMWBIn, AluCMEMWBIn, RtdMEMWBIn,
				DmMEMWBOut, AluMEMWBOut, RtdMEMWBOut, RFWr, MemtoReg, MEMWBMemR );
//mem\wb register, 4 inputs, 4 outputs
  input             clk, rst;
  output             MEMWBMemR;
	input      [26:0] CtrlWB;
	input      [4:0]  RtdMEMWBIn;
	input      [31:0] DmMEMWBIn, AluCMEMWBIn;	
	output reg [4:0]  RtdMEMWBOut;
	output            RFWr;
	output            MemtoReg;
	output reg [31:0] DmMEMWBOut, AluMEMWBOut;
	
	reg [26:0] CtrlWBReg;

	always @(posedge rst) begin
	  CtrlWBReg = 0;
		RtdMEMWBOut = 0;
		DmMEMWBOut = 0;
		AluMEMWBOut = 0;
	end//end initial

	always @( posedge clk ) begin
	  CtrlWBReg <= CtrlWB;
		RtdMEMWBOut <= RtdMEMWBIn;
		DmMEMWBOut <= DmMEMWBIn;
		AluMEMWBOut <= AluCMEMWBIn;
	end//end always

	assign RFWr = CtrlWBReg[23];
	assign MemtoReg = CtrlWBReg[0];
	assign MEMWBMemR = CtrlWBReg[26];
endmodule


