;	Laboratorio de Micro
;   Practica 1  tanque  
;	Autores: Lemys Lopez, Vicente Rojas

.include "m328pdef.inc" 
.def V1 = R17 ; referencia usar en puerto de salida para v1 abierta
.def V2 = R18 ; referencia a usar en puerto de salida para v2 abierta
.def SENSORS = R19 ; referencia a registro cuyo valor binario de 2 bits sera usado para almacenar estado de sensores, 
.def NL = R24
.def NRAYA = R25
.def NH = R26
.def L = R21 ; referencia a registro con dato para mostrar L
.def RAYA = R22 ; referencia a registro con dato para mostrar -
.def H = R23 ; referencia a registro con dato para mostar H
.CSEG



INICIALIZAR: ; suponemos estado inicial de tanque vacio
LDI V1, $01; v1 abierta, v2 cerrada
LDI V2, $02; v2 abierta, v2 cerrada

LDI L, $8e; dato para mostrar L (ojo cambiar valor real segun pines en la salida del micro )
LDI RAYA, $7e; dato para mostrar - (ojo cambiar valor real segun pines en la salida del micro )
LDI H, $13; dato para mostrar H (ojo cambiar valor real segun pines en la salida del micro )

LDI NL, $00; nivel bajo 
LDI NRAYA, $01; nivel medio
LDI NH, $03; nivel alto

LDI R20, 0; 
OUT DDRC, R20 ; seteando puerto C como entrada de sensores de nivel
LDI R20, $03; 
OUT PORTC,R20 ; PULL UP EN PORTC encendida para bit 1 y 2  (entradas de sensores )

LDI R20, $03; 
OUT DDRB, R20 ; seteando puerto para salida de como estado de valvulas


LDI R20, $FC; 
OUT DDRD, R20 ; seteando puerto para salida como segmentos de un display 7 sefmentos 



INICIO: ;
IN SENSORS, PINC; leemos el estaod de sensores y guardamos
SBRC SENSORS, 1;		si el sensor de nivel alto se activa 
RJMP ACCIONH;			saltamos a ejecutar rutina de nivel alto
CP SENSORS, NL;         si el sensor de nivel bajo y alto estan desactivados
BREQ ACCIONL;           saltamos a ejecutar rutina de nivel bajo
CP SENSORS, NRAYA;      si al sensor de nivel bajo esta UNICAMENTE ACTIVO 
BREQ ACCIONRAYA;		saltamos a ejectura rutina de nivel medio
RJMP INICIO;



ACCIONL:
OUT PORTB, V1; abrimos v1 cerramos v2
OUT PORTD, L ; mostamos L
RJMP INICIO;
ACCIONRAYA:
OUT PORTD, RAYA ; mostamos -
RJMP INICIO;
ACCIONH:
OUT PORTB, V2; abrimos v2 cerramos v1
OUT PORTD, H ; mostamos H
RJMP INICIO;

