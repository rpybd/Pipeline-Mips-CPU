   
module IM (addr, dout);
//ctr of im, decide the output (0/real addr) of im
   input  [11:2] addr; 
   output  [31:0] dout;
     
   reg [31:0] imem[1023:0];
      
   assign dout = imem[addr];
endmodule
