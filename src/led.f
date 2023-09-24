
HEX

\ Costanti e variabili

\ Pin GPIO
GPIO23              CONSTANT RED
GPIO24              CONSTANT GREEN

\ FSEL, valore da scrivere in GPFSEL per out mode, GPFSEL dei pin

\ LED Rosso
RED FSEL            CONSTANT RED_FSEL
RED OUT MODE        CONSTANT RED_OUT
RED GPFSEL          CONSTANT RED_GPFSEL   

\ LED Verde
GREEN FSEL          CONSTANT GREEN_FSEL
GREEN OUT MODE      CONSTANT GREEN_OUT
GREEN GPFSEL        CONSTANT GREEN_GPFSEL

VARIABLE FLAG

\ Word(s)
 
\ Queste word hanno lo scopo di caricare sullo stack la FSEL, il valore per la modalità
\ output e il registro GPFSELx associati ai LED
( -- fsel_n out_n gpfsel_n )
: RED_PIN   RED_FSEL RED_OUT RED_GPFSEL ;
: GREEN_PIN GREEN_FSEL GREEN_OUT GREEN_GPFSEL ;
\ Parola onnicomprensiva per richiamare entrambi i LED
( -- fsel_r out_r gpfsel_r fsel_g out_g gpfsel_g )
: LED_PINS RED_PIN GREEN_PIN ;
\ Parola da usare insieme a RED_PIN/GREEN_PIN per caricare sullo stack i registri GPSET0 e GPCLR0
: LED GPSET0 GPCLR0 ;
\ Parola usata per accendere un LED
: ON DROP ! ;
\ Parola usata per spegnere un LED
: OFF NIP ! ;

\ BLINK ( n -- )
\ Parola usata per far lampeggiare il LED rosso un numero di volte pari all'elemento in cima sullo stack
\ ES: 5 BLINK -> FA ACCENDERE E SPEGNERE IL LED 5 VOLTE
: BLINK 
    FLAG !
    BEGIN 
        RED LED ON
        300 MILLISECONDS DELAY 
        RED LED OFF
        300 MILLISECONDS DELAY
        FLAG @ 1 - FLAG !                   \ DECREMENTO FLAG AD OGNI ITERAZIONE
        FLAG @ 0=                           \ CONDIZIONE DI USCITA
    UNTIL ;

\ INIT_LEDS ( -- )
\ Parola usata per inizializzare entrambi i LED in modalità output
: INIT_LEDS
    LED_PINS ACTIVATE ;
    
\ LED_OK ( -- )
\ Word usata per notificare, in fase di debug, il corretto caricamento del file
: LED_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." led.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE button.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

LED_OK

