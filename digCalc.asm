; one digit calc

TITLE PRGM1
.MODEL SMALL
.STACK 100H

.DATA
A DB 0
B DB 0
SUM DB 0

MSG DB 10,"Value is greater than 9!!!",10,'$'

.CODE
MAIN PROC
    ; initialize DS
    MOV AX, @DATA	; Initalise all the data in ".DATA"
    MOV DS, AX		; Move Data to the Data Segment Regiter
    JMP START

ERROR:
    MOV AH, 09H		; Show Value for String
    MOV DX, offset MSG  ; Set Error Message To Be Shown
    INT 21H		; Show Error Message
START:
    MOV AH, 1		; Set Register to recieve value
    INT 21H		; Get input from user
    MOV A, AL		; Move Register into A
    SUB A, '0'		; Revert to ASCII

    MOV AH, 2		; Set Register to display value
    MOV DL, '+'         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    MOV AH, 1           ; Set Register to recieve value
    INT 21H		; Recieve value from user
    MOV B, AL		; Set value recieved into B
    SUB B, '0' 		; Revert from ASCII

    MOV BL, A		; Set A for register so we can manipulate
    MOV SUM, BL 	; Set value of sum to equal SUM = A
    MOV BL, B		; Set B for register so we can manipulate
    ADD SUM, BL		; Set value of sum to equal SUM = A + B

    CMP SUM, 9		; If Sum > 9
	JG ERROR	; Then start again

SHOW:
    MOV AH, 2		; Set Register to display value
    MOV DL, '='         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    ADD SUM, 48		; Set to ASCII

    MOV AH, 2		; Set Register to display value
    MOV DL, SUM         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    ; exit to DOS
    MOV AH, 4CH 	; Send Message to Exit DOS
    INT 21H		; Exit out of program
MAIN ENDP
END MAIN