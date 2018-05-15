`include "ctrl_encode_def.v"
module ALU(A, B, ALUOp, C);

  input  signed [31:0] A, B;
  input  signed [4:0]  ALUOp;
  output signed [31:0] C;
   
  reg [31:0] C;
  integer    i;
       
  always @( A or B or ALUOp ) begin
    case ( ALUOp )
      `ALUOp_NOP:  C = B;                        // NOP
      `ALUOp_ADDU: C = A + B;                    // ADDU
      `ALUOp_SUBU: C = A - B;                    // SUBU
      `ALUOp_OR:   C = A | B;                    // OR/ORI
      `ALUOp_SLL:  C = (B << A[10:6]);            // SLL/SLLV
      `ALUOp_SRL:  C = (B >> A[10:6]);	           // SRL/SRLV        
      `ALUOp_EQL:  C = (A == B) ? 32'd1 : 32'd0; // EQUAL
      `ALUOp_SRA: begin                         // SRA/SRAV
        for(i=1; i<=A[10:6]; i=i+1)
        C[32-i] = (B[31] == 0) ? 0 : 1;
        for(i=31-A[10:6]; i>=0; i=i-1)
        C[i] = B[i+A[10:6]];
      end
      
      
      `ALUOp_BNE:  C = (A != B) ? 32'd1 : 32'd0; // NOT EQUAL
      `ALUOp_SLT:  C = (A < B) ? 32'd1 : 32'd0;  // SLT/SLTI
      `ALUOp_SUB:  C = A - B;                    // SUB
      `ALUOp_ADD:  C = A + B;                    // ADD
      `ALUOp_AND:  C = A & B;                    // AND/ANDI
      `ALUOp_XOR:  C = A ^ B;                    // XOR/XORI
      `ALUOp_NOR:  C = ~(A | B);                 // NOR
      `ALUOp_SLTU: C = ({1'b0, A} < {1'b0, B}) ? 32'd1 : 32'd0; // SLTU/SLTIU 
      `ALUOp_GT0:  C = (A >  0) ? 32'd1 : 32'd0; // Great than 0
      `ALUOp_GE0:  C = (A >= 0) ? 32'd1 : 32'd0; // Great than & equal 0
      `ALUOp_LT0:  C = (A <  0) ? 32'd1 : 32'd0; // Less than 0
      `ALUOp_LE0:  C = (A <= 0) ? 32'd1 : 32'd0; // Less than & equal 0 
      
                                  
      default:   C = 32'd0;                	   // Undefined
    endcase
  end // end always

endmodule
    

