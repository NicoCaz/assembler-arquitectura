"""

"""

NULL equ -1
ANT EQU 3
SIG EQU 4
LISTA_DOBLE EQU 100


PUSH X ;ARCHIVO  
PUSH V ; USUARIOS
PUSH LISTA_DOBLE
CALL CREO_LISTA_USUARIOS
ADD SP,3


CREO_LISTA_USUARIOS:PUSH BP
                    MOV BP,SP
                    PUSH AX
                    PUSH BX
                    PUSH CX
                    PUSH DX
                    MOV AX,[BP+4] ;ARCHIVO
                    MOV BX,AX
                    ADD AX,3

                    PUSH AX
                    PUSH 3
                    CALL SACO_PERMISOS
                    ADD SP,2
                    CMP FX,1
                    JZ TODOS_TIENEN_PERMISO
                    PUSH AX
                    PUSH 2
                    CALL SACO_PERMISOS
                    ADD SP,2
                    CMP FX,1
                    JZ GRUPO_TIENE_PERMISOS
             OWENWR:PUSH AX
                    PUSH 1
                    CALL SACO_PERMISOS
                    ADD SP,2
                    CMP FX,1
                    JZ OWENWR_TIEN_PERMISOS

TODOS_TIENEN_PERMISO:PUSH [BP+3]
                     PUSH 3
                     PUSH [BP+2]
                     CALL CREO_LISTA_DOBLE
                     ADD SP+3
                     JMP FIN_CREO_LISTA_USUARIOS

GRUPO_TIENE_PERMISOS:PUSH [BP+3]
                     PUSH 2
                     PUSH [BP+2]
                     CALL CREO_LISTA_DOBLE
                     ADD SP+3
                     JMP OWENWR


OWENWR_TIEN_PERMISOS:PUSH [BP+3]
                     PUSH 1
                     PUSH [BP+2]
                     CALL CREO_LISTA_DOBLE
                     ADD SP+3
                     JMP FIN_CREO_LISTA_USUARIOS                     

//  PUSH USUARIOS
//  PUSH 1 PARA DUEÑO , 2 PARA GRUPO Y 3 PARA OTROS 
//  PUSH LISTA
CREO_LISTA_DOBLE:PUSH BP
                 MOV BP,SP
                 PUSH AX
                 PUSH BX
                 


// PUSH PERMISOS
// PUSH 1 PARA DUEÑO , 2 PARA GRUPO Y 3 PARA OTROS 
// DEVUELVE EN FX SI TIENE PERMISO DE ESCRITURA
SACO_PERMISOS:PUSH BP
              MOV BP,SP
              PUSH AX
              PUSH BX

              MOV AX,[BP+3]
              
              CMP [BP+2],1
              JZ ES_DUENIO

              ES_DUENIO:MOV BX,AX
                        SHR BX,7
                        AND BX,%001
                        CMP BX,%001
                        JZ TIENE_PERMISOS
                        JMP NO_TIENE_PERMISOS

              ES_GRUPO:MOV BX,AX
                        SHR BX,4
                        AND BX,%001
                        CMP BX,%001
                        JZ TIENE_PERMISOS
                        JMP NO_TIENE_PERMISOS
              ES_OTRO:MOV BX,AX
                        SHR BX,1
                        AND BX,%001
                        CMP BX,%001
                        JZ TIENE_PERMISOS
                        JMP NO_TIENE_PERMISOS

NO_TIENE_PERMISOS:MOV FX,0
                JMP FIN_SACO_PERMISOS

TIENE_PERMISOS: MOV FX,1
                JMP FIN_SACO_PERMISOS

JMP FIN_SACO_PERMISOS:POP BX
                      POP AX
                      MOV SP,BP
                      POP BP
                      RET