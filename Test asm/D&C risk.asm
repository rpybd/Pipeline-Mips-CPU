# Test File for 13 Instruction, include:
# ADDU/SUBU/ORI/SLL/SRL/SRA/LW/SW/BEQ/J/LUI/JAL/JR
################################################################
### Make sure following Settings :
# Settings -> Memory Configuration -> Compact, Data at address 0

.text	
	ori $3, $0, 0x1234
	ori $4, $0, 0x5678
	sw $4, 4($0)
	sw $3, 8($0)		
	_lone:
	lw $5, 4($0)
	beq $2, $5, _lone
	_ltwo:
	lw $6, 8($0)
	addu $7, $3, $6
	beq $6, $7, _ltwo
	_lthree:
	addu $8, $2, $3
	beq $7, $8, _lthree
	jal _p
	ori $2, $0, 0x1230
	j _lone
_p:
	lui $3, 0x2017
	beq $3, $2, _lone 
	addu $3, $2, $4
	sra $3, $3, 2
	jr $ra
	
