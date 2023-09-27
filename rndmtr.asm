;adds two digits upto 9

TITLE RandMeter
.MODEL SMALL
.STACK 100H

.DATA
EMPTY_CHAR DB '-'
FILL_CHAR DB '#'
FILL_AMOUNT DW 9
FILL_TOTAL DW 9


ASK_MSG DB "Please input a number (0-9): $"

.CODE
MAIN PROC

	; initialize DS
	MOV AX, @DATA				; Set @DATA to the Acc Register
	MOV DS, AX					; Initalise the Display Register with @DATA
		
	; Show String	
	MOV AH, 09H					; Get Register ready to show String value
	MOV DX, OFFSET ASK_MSG		; Load Offset of the String into the register
	INT 21H						; Show value of ASK_MSG
	; Get number value from the console
	MOV AH, 1					; Prepare Register to recieve value
	INT 21H						; Get Value From Prompt
	; Set the value gained to the FILL_AMOUNT variable
	MOV FILL_AMOUNT, AX			; Get value input, and put it to fill amount (the amoount of FILL_CHARS)
	SUB FILL_AMOUNT, '0'		; Subtract it by the value which unicode assigns to decimal number 0 (48)
	; Show new line, so we have a cleaner output
	MOV AH, 2					; Prepare Show values in the prompt (this will persist for most the program)
	MOV DX, 10					; New Line character
	INT 21H						; Show the newline
	
	MOV CL, FILL_AMOUNT			; Get the amount of times we are iterating through (FILL_AMOUNT)
	MOV BL, 0					; Register here so we can compare FILL_AMOUNT and 0
	MOV DX, FILL_CHAR			; Set the display register to the value which we will show for filled parts
	
	; If the FILL_AMOUNT is 0 (NO FILLING CHARACTERS)
	CMP FILL_AMOUNT, BL			; If Fill_Amount ************ 0
		JNE FILL				; 				 Not Equal To   Then Jump to FILL
		JMP END_FILL			;				 Equal To		Then Jump to END_FILL
	
	FILL:						; Set back here if we need to input a new FILL character
		INT 21H					; Show the associated character
		LOOP FILL				; If CL is not run FILL_AMOUNT of times, loop again
	END_FILL:					; Label to enter the empty meter
	
	MOV CL, FILL_TOTAL			; Get the amount of times we are iterating throug 
	
	; If the FILL_AMOUNT IS EQUAL TO FILL_TOTAL (ALL FILLING CHARACTERS)
	CMP FILL_AMOUNT, CL			; If Fill_Amount ************************ 0 
		JE END_EMPTY			;				 Equal To                    Then Jump to END_EMPTY
		
	SUB CL, FILL_AMOUNT			; this will be shown by the equation CL=FILL_TOTAl-FILL_AMOUNT
		
	MOV DX, EMPTY_CHAR			; Set the display register to the value which we will show for filled parts
	EMPTY:						; Set back here if we need to input a new EMPTY character
		INT 21H					; Show the associated character
		LOOP EMPTY				; If CL is not run (FILL_TOTAL - FILL_AMOUNT) of times, loop again
	END_EMPTY:					; Label to Terminate Program
		
	; exit to DOS	
	MOV AX, 4C00H				; Set Directive to Exit Program
	INT 21H						; Exit the program
	
	
MAIN ENDP
END MAIN