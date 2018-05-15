module PC( clk, rst, NPC, PC);
  //receive addr form NPC and provide addr for NPC
   input         clk;
   input         rst;
   input  [31:2] NPC;//dealt data from NPC
   output [31:2] PC; //use high 30 to avoid add 4, sll 2
   
   reg [31:2] PC;
   reg [1:0] tmp;
               
   always @(posedge clk or posedge rst) begin
      if ( rst ) 
         {PC, tmp} <= 32'h0000_3000;   
      else
         PC <= NPC;
   end // end always  
          
endmodule

