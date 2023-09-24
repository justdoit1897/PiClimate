HEX
\\   
\\ Definizione di costanti per il setting del registro GPPUD
\\  
1                   CONSTANT DOWN
2                   CONSTANT UP
\\  
\\ Definizione di costanti per la gestione del GPIO associato al bottone di reset
\\  
GPIO8               CONSTANT RESET_BTN
GPIO8 FSEL          CONSTANT GPIO8_FSEL
GPIO8 INP MODE      CONSTANT GPIO8_INPUT
GPIO8 GPFSEL        CONSTANT GPIO8_GPFSEL
\\  
\\ RESET_PIN ( -- fsel input_mode gpfsel )
\\ Permette di caricare sullo stack le informazioni per impostare il pin associato
\\ al bottone di reset in modalità input
\\  
: RESET_PIN GPIO8_FSEL GPIO8_INPUT GPIO8_GPFSEL ;
\\  
\\ SET_PULL ( gpio pud --  )
\\ Permette di eseguire le operazioni necessarie all'impostazione di un pin passato in input
\\ in pull-up/pull-down (modalità passata in input). Avendo utilizzato un modello precedente al 4
\\ bisogna seguire un protocollo più articolato, che prevede di:
\\ 1. scrivere nel registro GPPUD il valore di pud per abilitare il controllo pull-up/pull-down
\\ 2. attendere 150 cicli di clock
\\ 3. impostare a 1 il bit nel registro GPPUDCLK0/1 corrispondente al numero del pin di cui abilitare
\\  il controllo, per abilitare il segnale di clock ad esso associato
\\ 4. attendere ulteriori 150 cicli di clock
\\ Dal momento che il pulsante dev'essere in pullup perpetuo, vengono omesse le ultime due fasi:
\\ 5. scrivere nel registro GPPUD per rimuovere il segnale di controllo
\\ 6. scrivere nel registro GPPUDCLK0/1 per rimuovere il clock
\\ 
: SET_PULL
    GPPUD !
    150 MILLISECONDS DELAY
    GPPUDCLK0 DUP @
    ROT 2DUP
    BIC >R
    OR OVER !
    150 MILLISECONDS DELAY
    R> SWAP ! ;
\\  
\\ INIT_BTN ( -- )
\\ Permette di inizializzare il pulsante di reset, abilitando la modalità di input sul pin associato,
\\ impostando per esso la modalità pull-up e attivando due registri per l'individuazione di eventi:
\\ GPREN0 (per il rilevamento di innalzamenti di tensione, ossia transizioni del tipo '011') e GPFEN0
\\ (per il rilevamento di abbassamenti di tensione, ossia transizioni del tipo '100').
\\  
: INIT_BTN ( -- )
    RESET_PIN ENABLE_PIN
    RESET_BTN UP SET_PULL
    RESET_BTN GPREN0 !
    RESET_BTN GPFEN0 ! ;
\\  
\\ IS_CLICKED ( gpio --  )
\\ Parola che permette di controllare se un evento è stato registrato per il pin associato. L'evento,
\\ se esiste, viene scritto nel registro GPEDS0 al bit corrispondente dopo che viene rilevata una transizione
\\ '010', motivo per cui devono essere stati abilitati i bit corrispondenti nei registri GPREN0 e GPFEN0.
\\ 
: IS_CLICKED DUP >R GPEDS0 @ AND R> N_GPIO RSHIFT 0 = IF TRUE ELSE FALSE THEN ;
\\ 

: BUTTON_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." button.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE dht.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

BUTTON_OK
