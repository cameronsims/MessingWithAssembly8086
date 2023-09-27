;adds two digits upto 9

TITLE PRGM1
.MODEL SMALL
.STACK 100H

.DATA
A DW 2
B DW 5
SUM DW ?

.CODE
MAIN PROC

	; initialize DS
	MOV AX, @DATA
	MOV DS, AX
	
	MOV CX, 5
	MOV AH, 2
	MOV DL, '*'
	NEXT:
		; Get values
		MOV AH, 1
		INT 21H
		MOV AH, 2
		MOV A, AL
		SUB A, 48
		
		MOV AH, 2
		MOV DL, '+'
		INT 21H
		
		MOV AH, 1
		INT 21H
		MOV AH, 2
		MOV B, AL
		SUB B, 48
		
		MOV AH, 2
		MOV DL, '='
		INT 21H
		; add the numbers
		MOV AX, A
		ADD AX, B
		MOV SUM, AX
		; convert from ASCII to actual numbers
		MOV BL, 10
		DIV BL ; getting least significant digit
		ADD AH, '0' ; converting L.S. digit to ASCII
		MOV DH, AH ; storing L.S. digit temporarily
		MOV AH, 0
		DIV BL ; getting most significant digit
		ADD AH, '0' ; converting M.S. digit into ASCII
		MOV DL, AH ; displaying M.S. digit
		MOV AH, 2
		INT 21H
		MOV DL, DH ; displaying least significant digit
		INT 21H
		
		MOV DL, 10
		INT 21H
		
		LOOP NEXT
		
	; exit to DOS
	MOV AX, 4C00H
	INT 21H
	
	
MAIN ENDP
END MAIN