
HEX
\ 
\ Per avere una gestione dei tempi quanto più real-time, usiamo il System Timer del RPi.
\ È dotato di quattro registri a 32-bit (canali) per la gestione del tempo ed un contatore a 64-bit
\ Ognuno dei canali è associato ad un registro di confronto dell'output, usato per un confronto con
\ i 32 bit meno significativi del contatore. Quando i due valori coincidono, il System Timer genera un segnale
\ che indica l'avvenuta coincidenza per un certo canale, passato in input al controller per gli interrupt
\ L'indirizzo fisico (hardware) del System Timer per quest'implementazione è 0x20003000
\ 
RPI1_BASE 3000 +    CONSTANT TIMER_BASE
TIMER_BASE 4 +      CONSTANT TIMER_COUNT
\ 
DECIMAL
\\ 
\\ MILLISECONDS ( ms -- us )
\\ Permette di convertire in microsecondi un numero di millisecondi passato in input
\\ 
: MILLISECONDS 1000 * ;
\\ 
\\ SECONDS ( s -- us )
\\ Permette di convertire in microsecondi un numero di secondi passato in input
\\ 
: SECONDS 1000 * MILLISECONDS ;
\\ 
\\ DELAY ( nops -- )
\\ Manda il sistema in uno stato di busy-wait per un numero di operazioni passato in input
\\ simulando un cronometro
\\ 
: DELAY 
    BEGIN 
        1 - DUP
        0 =   
    UNTIL 
    DROP ;
\\ 
\\ CURRENT_TIME ( -- time )
\\ Permette di prelevare il valore di clock attuale del CLO_REGISTER 
\\ 
: CURRENT_TIME ( -- time ) TIMER_COUNT @ ;
\\ 
\\ CLK_DELAY ( us -- )
\\ Pone il sistema in busy-wait per un certo numero di microsecondi passato in input
\\ 
: CLK_DELAY CURRENT_TIME BEGIN 2DUP CURRENT_TIME - ABS SWAP > UNTIL 2DROP ;

: TIME_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." time.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE led.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

TIME_OK
