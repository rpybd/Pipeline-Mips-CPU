`include "ctrl_encode_def.v"
module NPC(  rst, PC, NPCOp, IMM, RA, NPC, Wr, IFlush );
//receive addr and ctr signals, deal with them then decide follow steps
   input         rst;
   input         Wr, IFlush;
   input  [31:2] PC;        //addr data from PC, use 30 to match PC format
   input  [1:0]  NPCOp;     //ctr signals
   input  [25:0] IMM;       //high bits of instructions: 25-0
   input  [31:0] RA;
   output [31:2] NPC;       //addr data back to PC
   
   reg [31:2] NPC;
   reg [1:0] tmp;
   
   always @(*) begin
      if ( rst )
        {NPC, tmp} <= 32'h0000_3004;
      else if( Wr ) begin   //write enable     
        case (NPCOp)
          `NPC_PLUS4: NPC = PC + 1;                           //normally works
          `NPC_BRANCH: begin
            if(IFlush)
              NPC = PC + {{14{IMM[15]}}, IMM[15:0]}; 
            else
              NPC = PC + 1;         
              //branch ins, ext IMM[15:0] to 30 bit. (16->32, sll 2)
          end
          `NPC_JUMP: NPC = {PC[31:28], IMM[25:0]};            
              //jump ins, PC's high 4 adds IMM's 26
          `NPC_JR: NPC = RA[31:2];
          default: ;
        endcase
      end //write enable
      else if( !Wr )
        NPC = PC; //write unable
   end // end always
   
endmodule


