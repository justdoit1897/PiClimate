
HEX

20000000            CONSTANT RPI1_BASE

RPI1_BASE 200000 +  CONSTANT GPIO_BASE

GPIO_BASE           CONSTANT GPFSEL0
GPIO_BASE 04 +      CONSTANT GPFSEL1
GPIO_BASE 08 +      CONSTANT GPFSEL2
GPIO_BASE 1C +      CONSTANT GPSET0
GPIO_BASE 28 +      CONSTANT GPCLR0
GPIO_BASE 34 +      CONSTANT GPLEV0

GPIO_BASE 40 +      CONSTANT GPEDS0

GPIO_BASE 4C +      CONSTANT GPREN0
GPIO_BASE 58 +      CONSTANT GPFEN0

GPIO_BASE 94 +      CONSTANT GPPUD
GPIO_BASE 98 +      CONSTANT GPPUDCLK0

\ **** Gestione GPIO ****

\ *** Costanti ***

DECIMAL

0   BILS            CONSTANT GPIO0
1   BILS            CONSTANT GPIO1
2   BILS            CONSTANT GPIO2
3   BILS            CONSTANT GPIO3
4   BILS            CONSTANT GPIO4
5   BILS            CONSTANT GPIO5
6   BILS            CONSTANT GPIO6
7   BILS            CONSTANT GPIO7
8   BILS            CONSTANT GPIO8
9   BILS            CONSTANT GPIO9

10  BILS            CONSTANT GPIO10
11  BILS            CONSTANT GPIO11
12  BILS            CONSTANT GPIO12
13  BILS            CONSTANT GPIO13
14  BILS            CONSTANT GPIO14
15  BILS            CONSTANT GPIO15
16  BILS            CONSTANT GPIO16
17  BILS            CONSTANT GPIO17
18  BILS            CONSTANT GPIO18
19  BILS            CONSTANT GPIO19
20  BILS            CONSTANT GPIO20

21  BILS            CONSTANT GPIO21
22  BILS            CONSTANT GPIO22
23  BILS            CONSTANT GPIO23
24  BILS            CONSTANT GPIO24
25  BILS            CONSTANT GPIO25
26  BILS            CONSTANT GPIO26
27  BILS            CONSTANT GPIO27

\ ** Costanti FSEL **

0                   CONSTANT INP
1                   CONSTANT OUT
2                   CONSTANT ALT5
3                   CONSTANT ALT4
4                   CONSTANT ALT0
5                   CONSTANT ALT1
6                   CONSTANT ALT2
7                   CONSTANT ALT3

\ *** Word(s) ***

\ Questa word ha lo scopo di prelevare il valore in cima al TOS, corrispondente alla maschera per il pin GPIO n, e di restituire 
\ un numero decimale corrispondente alla rappresentazione numerica del bit più significativo impostato a 1 nella maschera.
\ È l'operazione inversa a BILS.

( gpio_mask -- gpio_number )
: N_GPIO 
    0 SWAP 
    BEGIN 
        DUP 2 MOD 
        0 = IF 
            1 RSHIFT SWAP 1+ SWAP 
        ELSE 
        THEN 
        DUP 2 = 
    UNTIL 
    DROP 1+ ;

\ Questa word ha lo scopo di prelevare il valore in cima al TOS, corrispondente alla maschera per il pin GPIO n, e di ritornare
\ un numero decimale corrispondente alla rappresentazione numerica del bit meno significativo

( gpio_mask -- gpio_lsb )
: GPIO_LSB N_GPIO 10 MOD 3 * ;

\ ** Word(s) FSEL **
\ Questa word ha lo scopo di prelevare il valore in cima allo stack, corrispondente alla maschera per il pin GPIO, e di restituire
\ la maschera FSEL di tre bit ad esso corrispondente
\ es. GPIO2 (1<<6) FSEL_MASK -> 7<<6
: FSEL_MASK 
    DUP DUP
    2 + >R
    1 + >R
    BILS
    R> BILS OR
    R> BILS OR ;
\ Word comprensiva per ricavare i parametri utili alla FSEL di un pin GPIO passato in input, dato che restituisce il bit meno
\ signficativo della maschera e la maschera stessa.
: FSEL GPIO_LSB DUP FSEL_MASK ;
\ Questa word ha lo scopo di preparare il valore da scrivere nel registro FSEL opportuno, dato un pin GPIO e una AF in input
: MODE SWAP GPIO_LSB LSHIFT ;
\ 
\ ( GPIOn -- GPFSELx )
\ Questa word ha lo scopo di ricavare il registro GPFSEL opportuno per un pin GPIO passato in input.
: GPFSEL N_GPIO 10 / 4 * GPFSEL0 + ;

\ ** Word(s) GPSET & GPCLR ** 
\ ( GPIOn -- GPSETx)
\ Questa word ha lo scopo di ricavare il registro GPSET opportuno per un pin GPIO passato in input
: GPSET N_GPIO 32 / 4 * GPSET0 + ;
\ ( GPIOn -- GPCLRx)
\ Questa word ha lo scopo di ricavare il registro GPCLR opportuno per un pin GPIO passato in input
: GPCLR N_GPIO 32 / 4 * GPCLR0 + ;

\ ** Word(s) GPLEV **
\ ( GPIOn -- GPLEVx)
\ Questa word ha lo scopo di ricavare il registro GPLEV opportuno per un pin GPIO passato in input
: GPLEV 32 / 4 * GPLEV0 + ;
\ ( GPIOn -- 0|1)
\ Questa word ha lo scopo di ricavare il valore logico del bit associato a un pin GPIO passato in input
: PIN_LEVEL 
    DUP GPLEV @ 
    SWAP 32 MOD 
    BILS AND 
    IF 
        1 
    ELSE 
        0
    THEN ;

\ **** Impostazione GPIO ****

\ Variabili

VARIABLE TIMES

\ Word(s)

\ Questa word ha lo scopo di effettuare una SET FUNCTION per il pin GPIOn.
( GPIOn_FSEL GPIOn_XMODE GPFSELm -- )
: ENABLE_PIN
    DUP                 ( GPIOn_FSEL GPIOn_XMODE GPFSEL2 GPFSEL2 )
    >R @                ( GPIOn_FSEL GPIOn_XMODE GPFSEL2 @ )
    -ROT                ( GPFSEL2 @ GPIOn_FSEL GPIOn_XMODE )
    >R                  ( GPFSEL2 @ GPIOn_FSEL )
    BIC                 
    R>                  ( [ GPFSEL2 @ GPIOn_FSEL BIC ] GPIOn_XMODE )
    OR 
    R> ! ;          

\ Questa word è opposta alla funzione ENABLE_PIN ed ha lo scopo di effettuare una CLEAR FUNCTION per il pin GPIOn.
( fsel_n mode_n gpfsel_n -- )
: DISABLE_PIN
    NIP
    DUP >R
    @ SWAP BIC
    R> ! ;

\ Questa word ha lo scopo di effettuare una SET FUNCTION per un serie di pin GPIO un numero di volte specificato 
\ dalla costante TIMES. Partendo dalla considerazione che la word ENABLE_PIN richiede che siano presenti 3 elementi 
\ sullo stack, viene calcolata la divisione intera tra la profondità dello stack e 3 e il risultato viene memorizzato
\ nella variabile TIMES. All'interno del ciclo BEGIN...UNTIL viene richiamata la word ENABLE_PIN per attivare uno specifico
\ pin, viene decrementato il valore di TIMES di 1 ad ogni iterazione e viene verificato se la condizione di uscita è soddisfatta
\ per interrompere il ciclo.
( fsel_n mode_n gpfsel_n ... fsel_0 mode_0 gpfsel_0 -- )
: ACTIVATE 
    DEPTH 3 /
    TIMES !
    BEGIN
        ENABLE_PIN
        TIMES @ 1 - TIMES !                 \ DECREMENTO TIMES AD OGNI ITERAZIONE
        TIMES @ 0=                          \ CONDIZIONE DI USCITA
    UNTIL ;

\ Questa word è opposta alla funzione ACTIVATE ed ha lo scopo di effettuare una CLEAR FUNCTION per un serie di pin GPIO un 
\ numero di volte specificato dalla costante TIMES.
( fsel_n mode_n gpfsel_n ... fsel_0 mode_0 gpfsel_0 -- )
: DEACTIVATE
    DEPTH 3 /
    TIMES !
    BEGIN
        DISABLE_PIN
        TIMES @ 1 - TIMES !                 \ DECREMENTO TIMES AD OGNI ITERAZIONE
        TIMES @ 0=                          \ CONDIZIONE DI USCITA
    UNTIL ;

: GPIO_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." gpio.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE time.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

GPIO_OK

