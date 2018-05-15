`include "ctrl_encode_def.v"
`include "instruction_def.v"
module Ctrl (Op, Funct, CtrlStream,
              EXTOp, NPCOp, SpeRegAddr);
//control unit, 4 inputs, 5 outputs
//ins:(13) addu, subu, sll, srl, sra, ori, lui, lw, sw, beq, j, jal, jr    
   input [5:0]      Op;
   input [5:0]      Funct;
   output reg [1:0] EXTOp;
   output reg [1:0] NPCOp;
   output reg [4:0] SpeRegAddr;
   output reg [26:0]CtrlStream;
   
   always @(*) begin
     if( Op == 6'b000000 ) begin //R type, ADDU\SUBU\SLL\SRL\SRA
        if( Funct == `INSTR_ADDU_FUNCT || Funct == `INSTR_SUBU_FUNCT) begin//ADDU\SUBU
          EXTOp = 0;
          NPCOp = 0;
          SpeRegAddr = 0; 
          case( Funct )
            `INSTR_ADDU_FUNCT: CtrlStream = `Ctrl_ADDU;
            `INSTR_SUBU_FUNCT: CtrlStream = `Ctrl_SUBU;
            default: ;
          endcase
        end
        if( Funct == `INSTR_SLL_FUNCT || Funct == `INSTR_SRL_FUNCT || Funct == `INSTR_SRA_FUNCT) begin//SLL\SRL\SRA
          EXTOp = 0;
          NPCOp = 0;
          SpeRegAddr = 0;  
          case( Funct )
            `INSTR_SLL_FUNCT:  CtrlStream = `Ctrl_SLL;
            `INSTR_SRL_FUNCT:  CtrlStream = `Ctrl_SRL;
            `INSTR_SRA_FUNCT:  CtrlStream = `Ctrl_SRA;
            default: ;
          endcase
        end
     end
     if( Op == 6'b001101 ) begin//ORI type 
        EXTOp = `EXT_SIGNED;
        NPCOp = 0;
        SpeRegAddr = 0;
        CtrlStream = `Ctrl_ORI; 
     end
     if( Op == 6'b001111 ) begin//LUI type
        EXTOp = `EXT_HIGHPOS;
        NPCOp = 0;
        SpeRegAddr = 0;
        CtrlStream = `Ctrl_LUI; 
     end
     if( Op == 6'b100011 ) begin//LW type 
        EXTOp = 0;
        NPCOp = 0;
        SpeRegAddr = 0;
        CtrlStream = `Ctrl_LW; 
     end
     if( Op == 6'b101011 ) begin//SW type 
        EXTOp = 0;
        NPCOp = 0;
        SpeRegAddr = 0;
        CtrlStream = `Ctrl_SW; 
     end
     if( Op == 6'b000100 ) begin//BEQ type 
        EXTOp = 0;
        NPCOp = `NPC_BRANCH;
        SpeRegAddr = 0;
        CtrlStream = `Ctrl_BEQ; 
     end
     if( Op == 6'b000010 ) begin//J type 
        EXTOp = 0;
        NPCOp = `NPC_JUMP;
        SpeRegAddr = 0;
        CtrlStream = `Ctrl_J; 
     end
     if( Op == 6'b000011 ) begin//JAL type 
        EXTOp = 0;
        NPCOp = `NPC_JUMP;
        SpeRegAddr = 31;
        CtrlStream = `Ctrl_JAL; 
     end
     if( Op == 6'b000000 && Funct == `INSTR_JR_FUNCT ) begin//JR type 
        EXTOp = 0;
        NPCOp = `NPC_JR;
        SpeRegAddr = 0;
        CtrlStream = `Ctrl_JR; 
     end
   end//end always
   
   
endmodule
     

     
        
      
      
      
      


