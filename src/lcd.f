
HEX

\ Word creata con lo scopo di determinare se una sequenza di bit è un comando o un carattere restituendo, rispettivamente,
\ TRUE o FALSE. La differenza è rappresentata dal fatto che i comandi presentano il bit 8 posto a 1, che è invece 0 
\ nel caso dei caratteri.
( b -- 0/-1 )
: ?CMD DUP 8 RSHIFT 1 = ;
 

\ Word creata con lo scopo di impostare ad 1 al bit 8, per fare intendere allo slave che il byte che sta ricevendo è un comando.
( b -- b_cmd )
: CMD 100 OR ;

\ Word creata con lo scopo di determinare la costante di apertura della comunicazione da sommare al valore v presente
\ nel TOS per inviare un carattere (D) o un comando (C).
( v -- )
: ?CMD_OR_CHAR 
    TRUE = IF
        C
    ELSE
        D
    THEN
    OR ;

\ Questa word nasce con lo scopo di inserire sullo stack metà del byte effettivo (un nibble). Ricevuta in input una condizione
\ di verità p (0/T, 1/F) viene determinata, tramite la word ?CMD_OR_CHAR quale costante di apertura della comunicazione 
\ sommare al valore v per inviare un carattere (D) o un comando (C). Successivamente una copia del valore v viene sommata
\ alla costante di chiusura della comunicazione dello stesso nibble (8).
\ es. processare 5 come parte di un carattere produce i byte 5D e 58
\ es. processare 5 come parte di un comando produce i byte 5C e 58
( p v -- n1 n2 )
: NIBBLE
    DUP ROT
    ?CMD_OR_CHAR SWAP
    8 OR SWAP ;

\ Questa word nasce con lo scopo di, preso un Byte b dal TOS, annullarne tutti i bit tranne il MSB, 
\ poiché tutti i bit nel byte sono messi a 0 tranne i primi quattro.
( b -- msb_b )
: MSB F0 AND ;

\ Questa word, analogamente alla word MSB, nasce con lo scopo di restituire il LSB dal Byte presente nel TOS.
( b -- lsb_b )
: LSB F AND 4 LSHIFT ;

\ Word creata con lo scopo di processare il byte b e ritornare sullo stack un totale di 4 valori (due per ciascun nibble),
\ che compongono il Byte b che si desidera inviare.
( b -- v1 v2 v3 v4 )
: BYTE
    ?CMD SWAP 2DUP
    MSB NIBBLE 
    2SWAP
    LSB NIBBLE
    2SWAP ;

\ Word creata con lo scopo di inviare un totale di 4 messaggi tramite I2C, due per ciascun nibble, inserendo un opportuno delay
\ tra le varie operazioni.
( v1 v2 v3 v4 -- )
: SEND
    >I2C 1 MILLISECONDS DELAY
    >I2C 2 MILLISECONDS DELAY
    >I2C 1 MILLISECONDS DELAY
    >I2C 2 MILLISECONDS DELAY ;

\ Word creata con lo scopo di inviare, tramite I2C, un byte (comando o carattere).
( b -- )
: >LCD BYTE SEND ;

\ Elenco CMD(s) 

01                  CONSTANT CLEAR_DISPLAY
02                  CONSTANT RETURN_HOME

80                  CONSTANT ROW1
C0                  CONSTANT ROW2
ROW1 14 +           CONSTANT ROW3
ROW2 14 +           CONSTANT ROW4

14                  CONSTANT CURSOR_RSHIFT
10                  CONSTANT CURSOR_LSHIFT

0C                  CONSTANT CURSOR_OFF
0F                  CONSTANT CURSOR_ON
0E                  CONSTANT CURSOR_BLINK_OFF

: NUMBER 30 OR ;

VARIABLE COL

\ Word creata con lo scopo di posizionare il cursore in un punto specifico del display, che viene visto come una matrice 4x20. 
( row col -- )
: SET_CURSOR
    COL !
    CMD >LCD
    BEGIN 
        CURSOR_RSHIFT CMD >LCD
        COL @ 1 - COL !                   \ DECREMENTO FLAG AD OGNI ITERAZIONE
        COL @ 0=                           \ CONDIZIONE DI USCITA
    UNTIL ;

\ Elenco CHAR(s)

18                  CONSTANT DELETE
20                  CONSTANT SPACE

VARIABLE LEN

\ Questa word nasce con lo scopo di stampare una serie di caratteri o comandi presente sullo stack.
\ Viene calcolata la profondità dello stack e memorizzata in una variabile LEN, per conoscere il numero di iterazioni
\ per stampare tutti gli elementi dello stack.
\ Il ciclo BEGIN...UNTIL viene utilizzato per iterare attraverso gli elementi nello stack e stamparli sul display LCD. 
\ Dopo che il carattere/comando viene inviato, la variabile LEN viene decrementata di 1 e, successivamente, si verifica 
\ se il valore di LEN è pari a 0, ovvero se la condizione di uscita è stata soddisfatta.
( c1 c2 c3 ... cn -- )
: PRINT 
    DEPTH LEN !
    BEGIN 
        >LCD
        LEN @ 1 - LEN !                     \ DECREMENTO LEN AD OGNI ITERAZIONE
        LEN @ 0=                            \ CONDIZIONE DI USCITA
    UNTIL ;

VARIABLE STR_LEN

\ Questa word nasce con lo scopo di stampare una stringa di caratteri presente in memoria, 
\ specificata da "s_addr" (l'indirizzo di inizio della stringa) e "s_len" (la lunghezza della stringa).
\ Il ciclo BEGIN...UNTIL viene utilizzato per scorrere la stringa carattere per carattere fino a quando 
\ non viene raggiunta la fine della stringa (quando "STR_LEN" diventa 0).
\ All'interno del ciclo, "DUP C@" estrae il carattere corrente dalla stringa e lo invia alla destinazione di output 
\ (un display LCD nel nostro caso).
\ Dopo che il carattere viene inviato, la lunghezza della stringa viene ridotta di 1 ed il puntatore viene incrementato
\ di 1 in modo da puntare alla cella di memoria successiva.

( s_addr s_len -- )
: PRINT_STR
    STR_LEN !
    BEGIN
        DUP C@ >LCD
        STR_LEN @ 1- STR_LEN !
        1+
        STR_LEN @ 0=
    UNTIL
    DROP ;

\ *** Words utilizzate per il boot del sistema ***

( -- )
: SUBJECT
    CLEAR_DISPLAY CMD >LCD
    ROW2 2 SET_CURSOR S" Embedded Systems" PRINT_STR
    ROW3 2 SET_CURSOR S" A.A.   2022/2023" PRINT_STR ;

( -- )
: MARIO
    CLEAR_DISPLAY CMD >LCD
    ROW2 2 SET_CURSOR S" Mario Tortorici" PRINT_STR
    ROW3 2 SET_CURSOR S" Matr.   0737892" PRINT_STR ;

( -- )
: VINCENZO
    CLEAR_DISPLAY CMD >LCD
    ROW2 2 SET_CURSOR S" Vincenzo Fardella" PRINT_STR
    ROW3 2 SET_CURSOR S" Matr.     0738045" PRINT_STR ;

( -- )
: STUDENTS
    VINCENZO                                                        3 SECONDS DELAY
    MARIO                                                           3 SECONDS DELAY ;

( -- )
: PROJECT
    CLEAR_DISPLAY CMD >LCD
    ROW2 6 SET_CURSOR S" PiServer " PRINT_STR
    ROW3 2 SET_CURSOR S" Climate Control" PRINT_STR ;

( -- )
: WELCOME_MSG
    SUBJECT                                                         3 SECONDS DELAY
    STUDENTS
    PROJECT ;

( -- )
: LOAD_MSG
    CLEAR_DISPLAY CMD >LCD
    ROW2 2 SET_CURSOR S" Inizializzazione " PRINT_STR
    ROW3 6 SET_CURSOR S" in corso" PRINT_STR ;

\ *** Words utilizzate per l'output del sensore DHT22 ***

( -- )
: CELSIUS 
    ROW2 12 SET_CURSOR DF >LCD ;

( -- )
: TEMP 
    ROW2 CMD >LCD
    S" Temperature:   .   C" PRINT_STR
    CELSIUS ;

( -- )
: HUM 
    ROW3 CMD >LCD
    S" Humidity:      .   %" PRINT_STR ;
    \ ROW3 CMD 10# 19 SET_CURSOR S" %" PRINT_STR ;

( -- )
: TEMP_HUM_MSG
    CLEAR_DISPLAY CMD >LCD
    TEMP
    HUM ;

\ *** Words per la segnalazione dei warning ***

( -- )
: WARNING_MSG
    CLEAR_DISPLAY CMD >LCD
    ROW1 3 SET_CURSOR S" ! ATTENZIONE !" PRINT_STR ;

\ ** Temperatura **

( -- )
: LOW_TEMP_MSG
    WARNING_MSG
    ROW3 1 SET_CURSOR S" Temperatura sotto" PRINT_STR
    ROW4 CMD >LCD S" il livello ottimale" PRINT_STR ;

( -- )
: HIGH_TEMP_MSG
    WARNING_MSG
    ROW3 CMD >LCD S" Temperatura elevata" PRINT_STR
    ROW4 1 SET_CURSOR S" Avvio ventilazione" PRINT_STR ;

\ ** Umidità **

( -- )
: LOW_HUM_MSG
    WARNING_MSG
    ROW3 3 SET_CURSOR S" Umidita sotto" PRINT_STR
    ROW4 CMD >LCD S" il livello ottimale" PRINT_STR ;

( -- )
: HIGH_HUM_MSG
    WARNING_MSG
    ROW3 3 SET_CURSOR S" Umidita sopra" PRINT_STR
    ROW4 CMD >LCD S" il livello ottimale" PRINT_STR ;

\ *** Word(s) di inizializzazione display LCD ***

( -- )
: INIT_LCD 
    SET_SLAVE 02 CMD >LCD
    WELCOME_MSG ;

( -- )
: LCD_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." lcd.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE led.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

LCD_OK
