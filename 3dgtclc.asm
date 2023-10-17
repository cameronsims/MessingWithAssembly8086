; 3 digit calc

TITLE PRGM1
.MODEL SMALL
.STACK 100H

.DATA
A DW 0
B DW 0
SUM DW 0

MSG DB "Input a number between 000-999: $"

.CODE
MAIN PROC
    ; initialize DS
    MOV AX, @DATA	; Initalise all the data in ".DATA"
    MOV DS, AX		; Move Data to the Data Segment Regiter

    MOV AH, 09H		; Show Value for String
    MOV DX, offset MSG  ; Set Display Register to show Message
    INT 21H		; Show Message

    XOR AX, AX		; Set AX to 0

    MOV CX, 3		; Loop Register set to 3
    PUSH CX		; Save this value in the stack
    GET_A:              ; for i=3
        MUL A    	; Set value already at A to x10
        MOV A, AX	; Get value calculted above, set it to A
        MOV AH, 1       ; Set Register to recieve value
        INT 21H		; Recieve value from user
        SUB AL, '0'     ; Subtract into Binary (from ASCII)
        ADD A, AL	; Set value recieved into A
        MOV AX, 10      ; Set value to the register to multiply
        LOOP GET_A	; Return to get A

    MOV AH, 2		; Set Register to display value
    MOV DL, '+'         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    XOR AX, AX		; Set AX to 0

    POP CX              ; Set Loop Register to 3
    GET_B:              ; for i=3
        MUL B    	; Set value already at B to x10
        MOV B, AX	; Get value calculted above, set it to B
        MOV AH, 1       ; Set Register to recieve value
        INT 21H		; Recieve value from user
        SUB AL, '0'     ; Subtract into Binary (from ASCII)
        ADD B, AL	; Set value recieved into B
        MOV AX, 10      ; Set value to the register to multiply
        LOOP GET_B	; Return to get B

    MOV AH, 2		; Set Register to display value
    MOV DL, '='         ; Set Register to value that we wish to display
    INT 21H		; Show the value

    XOR AX, AX          ; Clear AX

    MOV AX, A		; Set value of A to AX
    ADD AX, B		; Add AX by B
    MOV SUM, AX		; Set SUM = A+B
    CALL SHOWVAL	; Show Number in AX
    

    ; exit to DOS
    MOV AH, 4CH 	; Send Message to Exit DOS
    INT 21H		; Exit out of program
MAIN ENDP

SHOWVAL PROC
;initialize count
    XOR CX, CX          ; Set CX to 0
    XOR DX, DX          ; Set DX to 0
    label1:             ; Label 1
        CMP AX,0        ; If AX = 0
            JE print1   ; JMP to Print1
        MOV BX,10       ; BX = 10
        DIV BX          ; BX = AX / BX
        PUSH DX         ; Keep it in Stack
        INC CX          ; Increase the time we are in the loop
        XOR DX, DX      ; Set DX to 0
        JMP label1      ; Jump back to the top
    print1:             ; Print the number
        CMP CX, 0       ; If CX = 0
            JE exit     ; Jump to the end of the program
        POP DX          ; Set value in stack
        ADD DX, '0'     ; Set this value to ASCII
        MOV AH, 2       ; Prepare to show integer
        INT 21H         ; Show Integer
        DEC CX          ; Decrease Amout of iterations
        JMP print1      ; PRINT AGAIN
     EXIT:              ; Exit the Function
         RET 0          ; Exit back to main
SHOWVAL ENDP
END MAIN
