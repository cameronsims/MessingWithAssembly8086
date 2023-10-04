;divide

TITLE PRGM1
.MODEL SMALL
.STACK 100H

.DATA
A DB 0
B DB 0

QUT DB 0
REM DB 0

.CODE
MAIN PROC
    ; initialize DS
    MOV AX, @DATA	; Initalise all the data in ".DATA"
    MOV DS, AX		; Move Data to the Data Segment Regiter

    MOV AH, 1		; Set Register to recieve value
    INT 21H		; Get input from user
    MOV A, AL		; Move Register into A
    SUB A, '0'          ; Set to ASCII

    MOV AH, 2		; Set Register to display value
    MOV DL, '/'         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    MOV AH, 1           ; Set Register to recieve value
    INT 21H		; Recieve value from user
    MOV B, AL		; Set value recieved into B
    SUB B, '0'          ; Set to ASCII

    MOV AH, 2		; Set Register to display value
    MOV DL, '='         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    MOV AH, 0		; Free up previous register
    MOV AL, A		; Set A to be divided by B
    DIV B		; B / A
    
    MOV QUT, AL 	; Set Quotient to the Quotient
    MOV REM, AH		; Set the remainder 

    ADD QUT, '0'        ; Set to ASCII
    ADD REM, '0'        ; Set to ASCII

    MOV AH, 2           ; Set Register to display value
    MOV DL, QUT		; Show Quotient
    INT 21H		; Display Quotient

    MOV AH, 2		; Set Register to display value
    MOV DL, 'r'         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    MOV AH, 2		; Set Register to display value
    MOV DL, REM		; Register to show remainder
    INT 21H
 
    ; exit to DOS
    MOV AH, 4CH 	; Send Message to Exit DOS
    INT 21H		; Exit out of program
MAIN ENDP
END MAIN