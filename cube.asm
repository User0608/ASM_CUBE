DATOS SEGMENT
    X DW ?
    Y DW ?
  
    LADO DW 20
    VIDEO DB ?
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
        CALL FACEL1
        CALL FACEL2
        CALL FACEL3  

          MOV X,200
        MOV Y,300
        CALL FACEL1
        CALL FACEL2
        CALL FACEL3  

          MOV X,400
        MOV Y,200
        CALL FACEL1
        CALL FACEL2
        CALL FACEL3  

        MOV X,300
        MOV Y,100
        CALL FACEL1
        CALL FACEL2
        CALL FACEL3  

         MOV X,200
        MOV Y,200
        CALL FACEL1
        CALL FACEL2
        CALL FACEL3   
   
 
   	;DETIENE EL PROGRAMA Y PIDE UN CARACTER
	MOV AH,00h		; petición para leer
	INT 16h		; Llama al BIOS

    MOV AH,00h		; función para establecer modo de video
	MOV AL,03H		; modo gráfico resolución 640x480
	INT 10h		; Llama al BIOS

	;interrupción de salida al sistema operativo
	MOV AX,4C00h	
	INT 21h	

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
                    MOV AL,09h		; color pixel
                    MOV BH,0h		; pagina
                    INT 10h	                   
                POP CX                
                LOOP COL
            INC DI
        POP CX       
        LOOP FIL 
    POP CX
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
                    MOV AL,12h		; color pixel
                    MOV BH,0h		; pagina                    
                    INT 10h	              
                    POP BX      
                POP CX                
                LOOP COLL2
            ADD DI,1
        POP CX       
        LOOP FILL2 
    POP CX
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
                    MOV AL,6h		; color pixel
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
   FACEL3 ENDP 
CODIGO ENDS

PILA SEGMENT STACK
	DB 360 DUP(?); separación de 160 bytes para uso de pila
PILA ENDS

END INIC
