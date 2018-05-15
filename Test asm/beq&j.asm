### Make sure following Settings :
# Settings -> Memory Configuration -> Compact, Data at address 0
.text
	ori $1, $0, 0x1234
	sw $1, 0($0)
	sw $1, 4($0)
	lw $2, 0($0)
	addu $2, $2, $2
	subu $2, $2, $1
	beq $1, $2, _appendix
_back:
	jr $ra	
_appendix:
	jal _back
	lui $3, 0x2017
	sll $4, $3, 2
	srl $5, $4, 2
	sra $6, $5, 2
	lw $7, 0($0)
	beq $6, $7, _appendix
	j _back

	


	
	
