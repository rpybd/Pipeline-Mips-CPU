module DataForward( EXMEMRFWr, MEMWBRFWr, IDEXRs, IDEXRt, EXMEMRtd, MEMWBRtd, sw, 
					ALUSrcA, ALUSrcB, rsR, rtR, MemDataSrc);
//detect data risk at EX stage
  input            rsR, rtR; 
	input      		    EXMEMRFWr, MEMWBRFWr;
	input            sw;
	input      [4:0] IDEXRs, IDEXRt;
	input      [4:0] EXMEMRtd, MEMWBRtd;
	output reg [1:0] ALUSrcA, ALUSrcB;
	output reg [1:0] MemDataSrc;

	always @(*) begin
	  ALUSrcA = 2'b00;
	  ALUSrcB = 2'b00;
	  MemDataSrc = 0;
		if( EXMEMRFWr && (EXMEMRtd != 0) && (EXMEMRtd == IDEXRs) && rsR ) 
			ALUSrcA = 2'b01;//nonLW
		else if( MEMWBRFWr && (MEMWBRtd != 0) && (MEMWBRtd == IDEXRs) && rsR && 
			(!(EXMEMRFWr && (EXMEMRtd != 0) && (EXMEMRtd == IDEXRs))) )
			ALUSrcA = 2'b10;//LW
			
		if( EXMEMRFWr && (EXMEMRtd != 0) && (EXMEMRtd == IDEXRt) && rtR ) begin
			if(!sw)
			 ALUSrcB = 2'b01;//nonLW
			else
			 MemDataSrc = 2'b01;
		end
		else if( MEMWBRFWr && (MEMWBRtd != 0) && (MEMWBRtd == IDEXRt) && rtR && 
			(!(EXMEMRFWr && (EXMEMRtd != 0) && (EXMEMRtd == IDEXRt))) ) begin
			if(!sw)
			 ALUSrcB = 2'b10;//LW
			else
			 MemDataSrc = 2'b10;
		end
	end//end always

endmodule