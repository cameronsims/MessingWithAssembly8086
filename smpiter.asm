; repeats an iteratable aspect of code

TITLE PRGM1
.MODEL SMALL
.STACK 100H

.DATA
nLoops DB 1
ITR DW 0

ITER_MSG DB "ITER#$"

.CODE
MAIN PROC	
	MOV AH, 1						; Set Register to display DX:DH/DL
	INT 21H							; Ask user for value
	MOV nLoops, AX					; Set value from prompt
	SUB nLoops, 48					; Change from Binary to UNICODE
	MOV CL, nLoops					; Set the amount of loops
	MOV ITR, 48						; Set to number 0, in binary
	MOV AH, 2   					; Set Register ready to show values in prompt
	NEXT:							; Begin the loop, this will be the header for the loop
		MOV DL, 10  				; Set the register to the value for a new line
		INT 21H						; Print the new line
		ADD ITR, 1					; Increase ITR by 1, shows current iterations
		; Show word "ITER#"
		MOV AH, 09H					; Get Register ready to show String value
		MOV DX, OFFSET ITER_MSG		; Load Offset of the String into the register
		INT 21H						; Show value of ITER_MSG
		; Show value of iteration
		MOV AH, 2   				; Set Register ready to show values in prompt
		MOV DX, ITR 				; Make the iterator next to be shown
		INT 21H   					; Show the iteration number in the console
		LOOP NEXT 					;	Return to the start of the loop, this won't happen when CX=ITR
	; exit to DOS
	MOV AX, 4C00H	; Register to exit
	INT 21H			; Exit the value
	
	
MAIN ENDP
END MAIN