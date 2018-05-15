module IDEX( rst, clk, CtrlStream, RD1In, RD2In, EXTIn, instrIDEXIn, 
			AluARF, AluBRF, instrIDEXOut, NCtrlWB, NCtrlM, ALUOp, RegDst, SwRt );
//id\ex register
 	inout             clk, rst;
	input      [26:0] CtrlStream;
	input      [31:0] RD1In, RD2In, EXTIn, instrIDEXIn;
	output reg [31:0] AluARF, AluBRF, instrIDEXOut;
	output reg [26:0] NCtrlWB, NCtrlM;
	output     [4:0]  ALUOp;
	output     [1:0]  RegDst;
	output reg [31:0] SwRt;

	always @(posedge rst) begin
		NCtrlWB = 0;
		NCtrlM = 0;
		AluARF = 0;
		AluBRF = 0;
		instrIDEXOut = 0;
		SwRt = 0;
	end//initial

	always @( posedge clk) begin
		NCtrlWB = CtrlStream;
		NCtrlM <= CtrlStream;
		instrIDEXOut <= instrIDEXIn;
		SwRt <= RD2In;
		case (CtrlStream[4:3])
		  2'b00:  AluARF = RD1In;
		  2'b01:  AluARF = EXTIn;
		endcase
		case (CtrlStream[2:1])
		  2'b00:  AluBRF = RD2In;
		  2'b01:  AluBRF = EXTIn;
		endcase
	end//end always

	assign ALUOp = NCtrlM[18:14];
	assign RegDst = NCtrlM[6:5];
endmodule
