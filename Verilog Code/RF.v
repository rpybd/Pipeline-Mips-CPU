
module RF( A1, A2, A3, WD, clk, RFWr, RD1, RD2,
          SpeRegAddr, PC4JAL );
//register files
   input  [4:0]  A1, A2, A3;    //input registers
   input  [4:0]  SpeRegAddr;
   input  [29:0] PC4JAL;
   input  [31:0] WD;            //write data
   input         clk;
   input         RFWr;
   output [31:0] RD1, RD2;      //output registers
   
   reg [31:0] rf[31:0];         //inside registers
   
   integer i;
   initial begin
       for (i=0; i<32; i=i+1)
          rf[i] = 0;
   end
   
   always @(*) begin
      if (RFWr)
         rf[A3] <= WD;          //write in 
      if( SpeRegAddr == 5'b11111 )
         rf[SpeRegAddr] <= {{PC4JAL + 1}, 2'b00};  
         
      $display("R[00-08]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", 0, rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7], rf[8]);
      $display("R[31]=%8X", rf[31]);

   end // end always

   assign RD1 = (A1 == 0) ? 32'd0 : rf[A1];//default read out
   assign RD2 = (A2 == 0) ? 32'd0 : rf[A2];
   
endmodule



