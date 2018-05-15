 module tb();
    
   reg clk, rst;
    
   PipeLineMips P_MIPS(
      .clk(clk), .rst(rst)
   );
    
   initial begin
      $readmemh( "mips2.txt" , P_MIPS.P_IM.imem ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", P_MIPS.P_PC.PC, P_MIPS.instrIF );       
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;
   
endmodule


