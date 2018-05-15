module IFID( clk, rst, PCIn, instrIFIDIn, PCOut, instrIFIDOut, Wr, IFlush );
//if\id register, 2 inputs & outputs
  input             clk, rst;
  input             Wr, IFlush;
	input      [29:0] PCIn;
	input      [31:0] instrIFIDIn;
	output reg [29:0] PCOut;
	output reg [31:0] instrIFIDOut;

	always @(posedge rst) begin
		PCOut = 0;
		instrIFIDOut = 0;
	end

	always @( posedge clk ) begin//write in IFD
		if( Wr ) begin
		  if( !IFlush ) begin
		    PCOut <= PCIn;
		    instrIFIDOut <= instrIFIDIn;
		  end	  
		  else //IFlush
		    instrIFIDOut <= 0;
		end
	end//end always

endmodule




