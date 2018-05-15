module DM( clk, addr, din, DMWr, dout );

   input  [11:2] addr;
   input  [31:0] din;
   //input  [3:0]  be;		          //write type define signal
   input         DMWr;
   input         clk;
   output [31:0] dout;
     
   reg [31:0] dmem[1023:0];     //1024 units data mem
   
   integer i;
   initial begin
       for (i=0; i<1024; i=i+1)
          dmem[i] = 0;
   end
     
   
   always @(negedge clk) begin
      if (DMWr) begin	  
         dmem[addr] <= din;  
      end
   end // end always

   assign dout = dmem[addr];

endmodule    

