;input a name and show it

TITLE InputName
.MODEL SMALL
.STACK 100H

.DATA
ASK_MSG DB "Please input a name: $"
USER_NAME DB 10,0,11 DUP(?), '$'
.CODE
MAIN PROC
	; initialize DS
	MOV AX, @DATA							; Set @DATA to the Acc Register
	MOV DS, AX								; Initalise the Display Register with @DATA	
	; Show String				
	MOV AH, 09H								; Get Register ready to show String value
	MOV DX, OFFSET ASK_MSG					; Load Offset of the String into the register
	INT 21H									; Show value of ASK_MSG
	; Get String From Console			
	MOV AH, 0AH								; Prepare Register to recieve string
	LEA DX, USER_NAME						; Load the address for name (so we can have it input)
	INT 21H									; Get Value From Prompt
	; Show Newline (so it doesn't screw with the above code
	MOV AH, 2								; Load Register to show value for a digit
	MOV DX, 10								; Set Display Register to have a newline character as it's value
	INT 21H									; Print Newline
	; Format String Correctly
	MOV BL, [USER_NAME + 1]					; Set Lower Register to the value of the length of the String + 1 for ($)
	MOV BH, 0								; Set higher register to the first place (0)
	MOV BYTE PTR [USER_NAME + 2 + BX], '$'	; Set last byte to $, which helps format the String in console
	; Show name in console
	LEA DX, USER_NAME+2						; Load Address of the String
	MOV AH, 09H								; Set Register to show a String
	INT 21H									; Show the strinb
	; exit to DOS				
	MOV AX, 4C00H							; Set Directive to Exit Program
	INT 21H									; Exit the program
MAIN ENDP
END MAIN