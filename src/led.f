
HEX

\ Costanti e variabili

GPIO23              CONSTANT RED
GPIO24              CONSTANT GREEN

RED FSEL            CONSTANT RED_FSEL
RED OUT MODE        CONSTANT RED_OUT
RED GPFSEL          CONSTANT RED_GPFSEL   

GREEN FSEL          CONSTANT GREEN_FSEL
GREEN OUT MODE      CONSTANT GREEN_OUT
GREEN GPFSEL        CONSTANT GREEN_GPFSEL

VARIABLE FLAG
VARIABLE IS_WARNING

\ Word(s)

\ Queste word hanno lo scopo di caricare sullo stack la 
( -- fsel_n out_n gpfsel_n )
: RED_PIN   RED_FSEL RED_OUT RED_GPFSEL ;
: GREEN_PIN GREEN_FSEL GREEN_OUT GREEN_GPFSEL ;

( -- fsel_r out_r gpfsel_r fsel_g out_g gpfsel_g )
: LED_PINS RED_PIN GREEN_PIN ;

: LED GPSET0 GPCLR0 ;

: ON DROP ! ;
: OFF NIP ! ;

: LOOP_BLINK 
    BEGIN 
        RED LED ON
        300 MILLISECONDS DELAY 
        RED LED OFF
        300 MILLISECONDS DELAY
    AGAIN ;

( n -- )
( ES: BLINK -> FA ACCENDERE E SPEGNERE IL LED 5 VOLTE )
: BLINK 
    5 FLAG !
    BEGIN 
        RED LED ON
        300 MILLISECONDS DELAY 
        RED LED OFF
        300 MILLISECONDS DELAY
        FLAG @ 1 - FLAG !                   \ DECREMENTO FLAG AD OGNI ITERAZIONE
        FLAG @ 0=                           \ CONDIZIONE DI USCITA
    UNTIL ;

: WARNING_BLINK
    TRUE IS_WARNING ! 
    IS_WARNING @ TRUE = IF
        BLINK
    THEN ;

