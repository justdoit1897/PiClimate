
HEX

GPIO2 FSEL          CONSTANT GPIO2_FSEL
GPIO2 ALT0 MODE     CONSTANT GPIO2_ALT0
GPIO2 GPFSEL        CONSTANT GPIO2_GPFSEL

GPIO3 FSEL          CONSTANT GPIO3_FSEL
GPIO3 ALT0 MODE     CONSTANT GPIO3_ALT0
GPIO3 GPFSEL        CONSTANT GPIO3_GPFSEL 

: SDA1_PIN GPIO2_FSEL GPIO2_ALT0 GPIO2_GPFSEL ;
: SCL1_PIN GPIO3_FSEL GPIO3_ALT0 GPIO3_GPFSEL ;

: I2C_PINS SDA1_PIN SCL1_PIN ;

\ **** Broadcom Serial Controller (BSC) ****

RPI1_BASE 804000 +  CONSTANT BSC1

BSC1                CONSTANT C_REGISTER
BSC1 4 +            CONSTANT S_REGISTER
BSC1 8 +            CONSTANT DLEN_REGISTER
BSC1 C +            CONSTANT A_REGISTER
BSC1 10 +           CONSTANT FIFO_REGISTER

\ Questa word ha lo scopo di eseguire un "store" controllato. Inizialmente, viene eseguito un "fetch" per recuperare il valore 
\ memorizzato in un registro. Successivamente, questo valore viene combinato tramite un operatore OR con il valore presente 
\ nello stack. Questa operazione è progettata per preservare i bit che erano precedentemente impostati su 1. 
\ Alla fine, il nuovo valore risultante viene memorizzato nuovamente nel registro.

( val reg -- )
: SET DUP >R @ OR R> ! ;

\ **** Gestione CONTROL_REGISTER ****

\ ** Costanti **

0                   CONSTANT READ
10# 4 BILS          CONSTANT CLEAR
10# 7 BILS          CONSTANT ST
10# 15 BILS         CONSTANT I2CEN

\ ** Word(s) **

\ Questa word ha lo scopo di impostare il tipo di trasferimento in modalità di scrittura
( -- )
: SET_WRITE         READ        C_REGISTER SET ;

\ Questa word ha lo scopo di ripulire la FIFO. Va osservato che ripulire la FIFO durante un trasferimento di dati
\ avrà come effetto l'annullamento dello stesso.
( -- )
: CLEAR_FIFO        CLEAR       C_REGISTER SET ;

\ Questa word ha lo scopo di abilitare un nuovo trasferimento BSC.
( -- )
: START_TRANSFER    ST          C_REGISTER SET ;

\ Questa word ha lo scopo di abilitare le operazioni BSC.
( -- )
: I2C_ENABLE        I2CEN       C_REGISTER SET ;

\ **** Gestione DLEN_REGISTER ****

\ ** Costanti **
1                   CONSTANT DLEN

\ ** Word(s) **

\ Questa word ha lo scopo di impostare il numero di bit da trasmettere/ricevere. 
\ Nel nostro caso si vuole trasmettere 1 Byte (8 bit) alla volta.
( -- )
: SET_DLEN DLEN DLEN_REGISTER SET ;

\ **** Gestione A_REGISTER ****

\ ** Costanti **

\ Indirizzo slave ottenuto tramite tool i2cdetect su Raspberry OS.
27                  CONSTANT ADDR

\ ** Word(s) **

\ Questa word ha lo scopo di specificare lo slave address del dispositivo I2C.
( addr -- )
: SET_SLAVE ADDR A_REGISTER SET ;

\ **** Gestione FIFO_REGISTER ****

\ ** Word(s) **

\ Questa word ha lo scopo di scrivere un byte di dati nel FIFO REGISTER.
( data -- )
: >FIFO FIFO_REGISTER ! ;

\ Questa word ha lo scopo di leggere un byte di dati dal FIFO REGISTER.
( data -- )
: FIFO> FIFO_REGISTER @ ;

\ Questa word ha lo scopo di:
\   * impostare il tipo di trasferimento in modalità di scrittura
\   * abilitare un nuovo trasferimento BSC
\   * abilitare le operazioni BSC, dato che se ciò non accade, i trasferimenti non possono essere effettuati

( -- )
: I2C_SEND
    SET_WRITE
    START_TRANSFER
    I2C_ENABLE ;

\ Questa word consente, ricevuto un Byte di dati, di:
\   * scrivere i dati nel FIFO REGISTER
\   * impostare il numero di bit da trasmettere/ricevere
\   * richiamare la subroutine I2C_SEND per attivare il controllore BSC ed iniziare un nuovo trasferimento. 

( data -- )  
: >I2C
    >FIFO
    SET_DLEN
    I2C_SEND ;

\ Questa word ha la finalità di inizializzare il bus I2C. Ha lo scopo di attivare i pin SDA1 e SCL1.
( -- )
: INIT_I2C I2C_PINS ACTIVATE ;

: I2C_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." i2c.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE lcd.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

I2C_OK

