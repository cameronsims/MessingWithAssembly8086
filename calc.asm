; 3 digit calc

TITLE PRGM1
.MODEL SMALL
.STACK 100H

.DATA

A DW 0
B DW 0
SUM DW 0

OP DB '+' ; +, -, *, /

EXP DB "Please enter:",10,13,"1 - Add",10,13,"2 - Sub",10,13,"3 - Mult",10,13,"4 - Division",10,13,"5 - Exit",10,13,"$" 
CALC DB "Input 2-3 Digit Numbers",10,13,"$"

.CODE

MAIN PROC
	; Intalise Data Segment
	MOV AX, @DATA			; Get Data segment (.data)
	MOV DS, AX				; Move all data to the DS register
	NewCalc:
		; Initalise all variables to 0
		MOV A, 0			; A = 0
		MOV B, 0			; B = 0
		MOV SUM, 0			; SUM = 0
		
		ASK_OP:
			MOV AH, 9		; Prepare to show String in console
			LEA DX, EXP 	; Load Header String
			INT 21H			; Show String in console
			
			MOV AH, 8		; Get input [next 21H] (do not show in console)
			INT 21H			; Get input
			SUB AL, '0' 	; Move to Binary number from ASCII
			MOV OP, AL		; Set operand
		
			CMP OP, 1		; Compare AH to 1
				JE PLUS_OP	; Prepare to add
			CMP OP, 2		; Compare AH to 2
				JE TAKE_OP  ; Prepare to subtract
			CMP OP, 3		; Compare AH to 3
				JE MULT_OP  ; Prepare to Multiply
			CMP OP, 4		; Compare AH to 4
				JE DIVD_OP	; Prepare to divide
			CMP OP, 5		; Compare AH to 5
				JNE ASK_OP	; End program
			JMP EXIT		; Jump to the beginning
				
		PLUS_OP:			; If we are adding
			MOV OP, '+'		; Set variable to +
			JMP EXIT_OP		; Jump to get numbers
		TAKE_OP:			; If we are subtracting
			MOV OP, '-'		; Set variable to -
			JMP EXIT_OP		; Jump to get numbers
		MULT_OP:			; If we are multiplying
			MOV OP, '*'		; Set variable to *
			JMP EXIT_OP		; Jump to get numbers
		DIVD_OP:			; If we are dividing
			MOV OP, '/'		; Set variable to /
		EXIT_OP:			; Exit to get numbers
		
		CALL GetCXDigit 	; Get A
		MOV A, BX			; Move Result into variable
			
		MOV AH, 2			; Prepare to show operation
		MOV DL, OP			; Send OP into Display Register
		INT 21H				; Show operation (held in OP)
			
		CALL GetCXDigit 	; Get B
		MOV B, BX			; Move Result into variable
			
		MOV AH, 2			; Prepare to show operation
		MOV DX, '='			; Send OP into Display Register
		INT 21H				; Show equals
		
		XOR BX, BX			; Clear BX
		MOV AX, A 			; Set A to AX register to set to SUM
		
		; Operation depending
		CMP OP, '-'			; If we are subtracting
			JE SUBTO		; Jump to subtract a value
		CMP OP, '*'			; If we are timesing
			JE MULTO		; Jump to multiply value
		CMP OP, '/'			; If we are dividing
			JE DIVTO		; Jump to divide
		; If it isn't any of the above, it is addition
		ADDTO:				; SUM = A + B
			ADD AX, B		; Set AX = A + B
			JMP SUMTOGETHER ; Jump to sum / show value
		SUBTO:				; SUM = A - B
			SUB AX, B		; Set AX = A - B
			JMP SUMTOGETHER	; Jump to sum / show value
		MULTO:				; SUM = A * B
			MUL B			; Multiply AX*B (result in DX:AX)
			JMP SUMTOGETHER	; Jumps to showing result
		DIVTO:
			XOR DX, DX		; Clear, so that we can put the Remainder here
			MOV BX, B		; Show BX 
			DIV BX			; Divide, [AX]/[BX] Quotient=[AX] Remainder=[DX]
			PUSH DX			; Save in memory
			CALL ShowValue  ; Show Quotient, we will show remainder below
			MOV AH, 2		; Show a character in prompt
			MOV DX, 'r'		; Show that it is the remainder
			INT 21H			; Show 'r' in prompt
			POP DX			; Get remainder, from stack
			MOV AX, DX		; Put remainder in [AX] (will be Sum)
			JMP SUMTOGETHER ; Show Remainder
		
		SUMTOGETHER:		; Show value in prompt
			MOV SUM, AX		; Send A equal to SUM
			CALL ShowValue	; Show Sum
			
			MOV CX, 2		; Prepare to put two new lines
			NEWLINE: 		; New line loop
				MOV AH, 2	; Prepare to show one value
				MOV DX, 10	; New Line
				INT 21H		; Show Newline
				MOV DX, 13  ; Carrage Return
				INT 21H		; Show Carrage Return
				LOOP NEWLINE; Jump back
			JMP NewCalc		; Jump to the beginning of the program
	EXIT:
		MOV AH, 4CH			; Prepare to go to DOS
		INT 21H				; Go to DOS
MAIN ENDP

; BX is the value we will move to
GetCXDigit PROC
	; Get three digits
	XOR AX, AX				; Clear AX register
	XOR BX, BX				; Clear BX register
	MOV CX, 3				; Ensure that we are dealing with 3 digit variables only
	NextDigit: 				; Prepare to get a new digit
		MUL BX				; Times current digit by 10 [00X] -> [0XY] -> [XYZ]
		MOV BX, AX			; Get the value which was calculated 
		MOV AH, 1			; Prepare to get a new value
		INT 21H				; Get one digit from user
		SUB AL, '0'			; Subtract the value which we got by the ASCII rep of 0
		XOR AH, AH			; Remove north-half of register
		ADD BX, AX			; Add this value to the BX register
		MOV AX, 10			; Prepare the register above to multiply by x10
		LOOP NextDigit		; Loop back to NextDigit (ensure its CX)
	RET 0					; Return function
GetCXDigit ENDP	
	
; Show value held in AX	
ShowValue PROC	
	; Initalise count	
	XOR CX, CX				; Set CX to 0
	XOR DX, DX				; Set DX to 0
	CMP AX, 0				; If there is no value at all
		JNE GetRemainder	; Skip below code to show 0
		
	MOV AH, 2				; Prepare to show character in prompt
	MOV DX, '0'				; Set 0 to DX
	INT 21H					; Show 0 in prompt
	JMP ExShowVal			; Exit this function
	
	GetRemainder:			; Get Remainder of a number by 19
		CMP AX, 0			; If AX = 0
			JE Print		; Jump to printing if the value is 0
		MOV BX, 10			; Set BX (multiplier to 10, because we are in base 10 which means the biggest remainder is 9
		DIV BX				; BX = AX / BX
		PUSH DX				; Push the value of DX into the stack
		INC CX				; Increase CX by 1
		XOR DX, DX			; Set DX to 0
		JMP GetRemainder	; Jump back to remainder
	Print:					; Print a Digit
		CMP CX, 0			; If we are on our last iteration, leave
			JE ExShowVal	; Exit this function
		POP DX				; Get value from DX
		ADD DX, '0'			; Set to binrary number from ASCII code
		MOV AH, 2			; Prepare to show value
		INT 21H				; Show Integer in DX
		DEC CX				; Decrease iteration amounts
		JMP Print			; Jump back to the top (print next digit)
	ExShowVal:				; Label to leave function
		RET 0				; Return
ShowValue ENDP

END MAIN