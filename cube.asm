DATOS SEGMENT
    X DW ?
    Y DW ?
    
    COLOR1 DB ?
    COLOR2 DB ?
    COLOR3 DB ?
  
    LADO DW ?
    VIDEO DB ?
    VELOCIDAD DW 10
DATOS ENDS


CODIGO SEGMENT
	ASSUME CS:CODIGO, DS:DATOS, SS:PILA

INIC:
	MOV AX,DATOS	; asigna a AX el desplazamineto DATOS
	MOV DS,AX	; asigna al registro DS la dirección inicial
	
    MOV AH,0FH
    INT 10H
    MOV VIDEO,AL

	MOV AH,00h		; función para establecer modo de video
	MOV AL,12h		; modo gráfico resolución 640x480
	INT 10h		; Llama al BIOS
            
        MOV X,50
        MOV Y,50
        MOV LADO,20
        MOV COLOR1,09H
        MOV COLOR2,12H
        MOV COLOR3,06H
        CALL BUCLE

   
    MOV AH,00h		; función para establecer modo de video
	MOV AL,03H		; modo gráfico resolución 640x480
	INT 10h		; Llama al BIOS

	;interrupción de salida al sistema operativo
	MOV AX,4C00h	
	INT 21h	


	BUCLE PROC NEAR	
		HEAD:				
				CALL DRAWING
				CALL LISTEN 			
				JNZ IZQ
				MOV AL,"3"				

			IZQ:	
				CMP AL, "4"
				JNZ DERE
				CALL MOV_I
				JMP HEAD
			
			DERE:
				CMP AL, "6"
				JNZ UP
			    CALL MOV_D
				JMP	HEAD

            UP:	
				CMP AL, "8"
				JNZ ABA
				CALL MOV_UP
				JMP HEAD
			
			ABA:
				CMP AL, "2"
				JNZ QUIT
			    CALL MOV_A
				JMP	HEAD
	
			QUIT:	
				CMP AL, "5"
				JNZ HEAD
		RET
	BUCLE ENDP
LISTEN  PROC NEAR
	MOV AH,06h    
 	MOV DL,0FFh   
 	INT 21h        
	RET
LISTEN ENDP	 

DRAWING PROC NEAR
        CALL FACEL1
        CALL FACEL2
        CALL FACEL3
        RET  
DRAWING ENDP
CLEAN PROC NEAR
     MOV COLOR1,00
     MOV COLOR2,00
     MOV COLOR3,00
     CALL DRAWING
     MOV COLOR1,09H
     MOV COLOR2,12H
     MOV COLOR3,06H
RET
CLEAN ENDP

MOV_D PROC NEAR
    CALL CLEAN
    MOV AX,VELOCIDAD
    ADD X,AX
RET
MOV_D ENDP

MOV_I PROC NEAR
    CALL CLEAN
    MOV AX,VELOCIDAD
    SUB X,AX
RET
MOV_I ENDP

MOV_UP PROC NEAR
    CALL CLEAN
    MOV AX,VELOCIDAD
    SUB Y,AX
RET
MOV_UP ENDP

MOV_A PROC NEAR
    CALL CLEAN
    MOV AX,VELOCIDAD
    ADD Y,AX
RET
MOV_A ENDP

FACEL1 PROC NEAR
  PUSH CX
        MOV CX,LADO
        MOV DI,X
        FIL:
        PUSH CX
                MOV CX,LADO
                MOV DX,Y
                COL:
                PUSH CX                
                    MOV CX,DI
                    ADD DX,1 
                    MOV AH,0Ch		; petición para escribir un punto
                    MOV AL,COLOR1		; color pixel
                    MOV BH,0h		; pagina
                    INT 10h	                   
                POP CX                
                LOOP COL
            INC DI
        POP CX       
        LOOP FIL 
    POP CX
    RET
FACEL1 ENDP

FACEL2 PROC NEAR
  PUSH CX
        MOV CX,LADO
        MOV DI,X             
        FILL2:
        PUSH CX
                MOV AX,LADO
                MOV CL,2
                DIV CL
                MOV CX,AX
                MOV DX,Y                
                MOV BX,DI
                COLL2:
                PUSH CX                
                    MOV CX,BX                    
                    SUB BX,1
                    PUSH BX
                    SUB DX,1                     
                    MOV AH,0Ch		; petición para escribir un punto
                    MOV AL,COLOR2		; color pixel
                    MOV BH,0h		; pagina                    
                    INT 10h	              
                    POP BX      
                POP CX                
                LOOP COLL2
            ADD DI,1
        POP CX       
        LOOP FILL2 
    POP CX
    RET
   FACEL2 ENDP

FACEL3 PROC NEAR
  PUSH CX
        MOV AX,LADO
        MOV CL,2
        DIV CL
        MOV CX,AX
        MOV DI,X
        MOV AX,Y           
        FILL3:
        PUSH CX
                MOV CX,LADO
                MOV DX,AX
                PUSH AX
                COLL3:
                PUSH CX                
                    MOV CX,DI   
                    ADD DX,1                     
                    MOV AH,0Ch		; petición para escribir un punto
                    MOV AL,COLOR3		; color pixel
                    MOV BH,0h		; pagina                    
                    INT 10h
                POP CX                
                LOOP COLL3
            SUB DI,1
            POP AX
            SUB AX,1
        POP CX       
        LOOP FILL3 
    POP CX
    RET
   FACEL3 ENDP 
CODIGO ENDS

PILA SEGMENT STACK
	DB 360 DUP(?); separación de 160 bytes para uso de pila
PILA ENDS

END INIC
