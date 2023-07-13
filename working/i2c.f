HEX
\\ Costanti
\\ Indirizzo di base ricavato dalla documentazione di pijFORTHos
20000000 CONSTANT BASE

\\ Displacements ricavati dalla documentazione BCM2835 ARM Peripherals
BASE 200000 + CONSTANT GPFSEL0

BASE 804000 + CONSTANT I2C_BASE
I2C_BASE 0 + CONSTANT C_REGISTER
I2C_BASE 8 + CONSTANT DLEN_REGISTER
I2C_BASE C + CONSTANT A_REGISTER
I2C_BASE 10 + CONSTANT FIFO_REGISTER

\\ Indirizzo slave ottenuto tramite tool i2cdetect su Raspberry OS
27 CONSTANT SLAVE_ADDRESS

\\ Utilita

: DELAY BEGIN 1 - DUP 0 = UNTIL DROP ;

: MS 1000 * DELAY ;

\\ All'avvio, GPFSEL0 ha un valore di 0x00048024, per abilitare l'interfaccia I2C occorre che i pin GPIO responsabili
\\ (i pin GPIO-2 e GPIO-3) siano impostati nelle rispettive FSEL ALT0 (rispettivamente, SDA1 e SCL1). I bit responsabili
\\ della FSEL per i pin GPIO-2 e GPIO-3 sono i bit 6-8 (GPIO-2) e 9-11 (GPIO-3), che vanno impostati nella configurazione
\\ 100. Per far ciò, definiamo due parole FORTH per configurare i pin.
\\ : ALT0_SDA GPFSEL0 DUP @ 100 XOR SWAP ! ;
\\ 0x00048024 -> 0x00048124 (0000 0000 0000 0100 1000 0000 0010 0100 -> 0000 0000 0000 0100 1000 0001 0010 0100)
: ALT0_SDA GPFSEL0 DUP @ 100 XOR SWAP ! ;

\\ : ALT0_SCL ( -- ) GPFSEL0 DUP @ 100 XOR SWAP ! ;
\\ 0x00048024 -> 0x00048824 (0000 0000 0000 0100 1000 0000 0010 0100 -> 0000 0000 0000 0100 1000 1000 0010 0100)
: ALT0_SCL GPFSEL0 DUP @ 800 XOR SWAP ! ;

\\ : CLEAR_FIFO ( -- ) 10 FIFO_REGISTER ! ;
\\ Viene utilizzata per resettare la FIFO attraverso il C_REGISTER (0x20804000) impostando a 1 il bit 4, associato alla
\\ azione di Clear FIFO
: CLEAR_FIFO 10 FIFO_REGISTER ! ;

\\ : >FIFO ( data --  ) FIFO_REGISTER ! ;
\\ Viene utilizzata per scrivere un byte di dati nel registro FIFO (0x20804010)
: >FIFO FIFO_REGISTER ! ;

\\ : SET_DLEN ( -- ) 1 DLEN_REGISTER ! ;
\\ Viene utilizzata per impostare a 1 il bit 0 nel DLEN_REGISTER (0x20804008) per indicare il numero di byte usati nella
\\ trasmissione 
: SET_DLEN 1 DLEN_REGISTER ! ;

\\ : START_TRANSFER ( -- ) 8080 C_REGISTER ! ; 
\\ Viene utilizzata per inizializzare un nuovo trasferimento con protocollo BSC, impostando a 1 i bit 15 e 7,
\\ ossia quelli atti ad attivare il controllore BSC e a iniziare un nuovo trasferimento
\\ 0x0 -> 0x00008080 (0000 0000 0000 0000 0000 0000 0000 0000 -> 0000 0000 0000 0000 1000 0000 1000 0000)
: START_TRANSFER 8080 C_REGISTER ! ;

\\ : TO_I2C ( b -- ) >FIFO SET_DLEN START_TRANSFER ;
\\ Viene utilizzata per inviare un byte b tramite I2C, eseguendo in sequenza le parole precedentemente definite
: TO_I2C
    >FIFO
    SET_DLEN
    START_TRANSFER ;

\\ : SEND_NIBBLE ( v p -- ) DUP ROT  IF C + ELSE D + THEN TO_I2C 1 MS 8 + TO_I2C 2 MS ;
\\ Viene utilizzata per inviare metà del byte effettivo (un nibble) tramite I2C. Ricevuta in input una condizione
\\ di verità p (1/T, 0/F) viene determinata la costante di 'apertura' della comunicazione da sommare al valore v
\\ per inviare un carattere (D) o un comando (C)
\\ Successivamente, viene inviata una versione di 'chiusura' della comunicazione dello stesso nibble
\\ es. inviare 5 come parte di un carattere produce i byte 5D e 58
\\ es. inviare 5 come parte di un comando produce i byte 5C e 58
: SEND_NIBBLE 
    DUP ROT 
    IF C +
    ELSE D +
    THEN
    TO_I2C 1 MS
    8 + TO_I2C 2 MS ;

\\ : SEND_BYTE ( b -- ) 2DUP F0 AND SEND_NIBBLE  F AND 4 LSHIFT SEND_NIBBLE 5 MS ;
\\ Viene utilizzata per separare il byte in due nibble per i 4 MSB e i 4 LSB, in modo da poter inviare un totale
\\ di 4 messaggi tramite I2C, due per ciascun nibble
: SEND_BYTE
    2DUP F0 AND SEND_NIBBLE 
    F AND 4 LSHIFT SEND_NIBBLE 5 MS ;

\\ : IS_CMD ( b -- p ) DUP 8 RSHIFT 1 = ;
\\ Viene utilizzata per determinare se una sequenza di bit è un comando o un carattere. La differenza è rappresentata
\\ dal fatto che i comandi presentano il bit 8 posto a 1, che è invece 0 nel caso dei caratteri
: IS_CMD DUP 8 RSHIFT 1 = ;

\\ : DISPLAY ( b -- ) IS_CMD SWAP SEND_BYTE ;
\\ Viene utilizzata per inviare tramite I2C un comando o un carattere, con alcuni operandi che cambiano in base 
\\ all'uno o all'altro caso (in questo senso viene controllato se b è un comando)
: DISPLAY IS_CMD SWAP SEND_BYTE ;

\\ : SET_SLAVE ( -- ) SLAVE_ADDRESS A_REGISTER ! ;
\\ Viene utilizzata per impostare il valore del registro A_REGISTER (0x2080400C) a quello relativo all'elemento slave del
\\ protocollo (in questo caso il display LCD)
: SET_SLAVE SLAVE_ADDRESS A_REGISTER ! ;

\\ : FUNCTION_SET ( -- ) 102 DISPLAY ;
\\ Viene utilizzata per inviare il comando FUNCTION SET al display. Il comando permette di definire la data length per
\\ l'interfaccia (usando un serializzatore I2C siamo costretti a impostare la modalita 4 bit), il numero di righe a display
\\ (impostato a 2) e il font type (se 5x8 o 5x10, nel nostro caso 5x8)
\\ La modalità di lettura dei data bits viene impostata attraverso il bit DL (D4) che se posto a 0, impone la modalità 4 bit,
\\ mentre se posto a 1 impone la modalità 8 bit.
\\ Poiché viene usato un serializzatore PCF8574, dei 12 pin potenziali del display, solo 8 vengono utilizzati, per cui
\\ adopereremo la modalità 4 bit.
\\ Il display LCD 2004 supporta due modalità di scrittura sul display, ossia a 1 e a 2 righe: nel primo caso, verrà utilizzato
\\ solo l'indirizzo 0x80 (corrispondente alla prima e terza riga del display), mentre nel secondo caso saranno utilizzati sia
\\ l'indirizzo 0x80 che quello 0xC0 (corrispondente alla seconda e quarta riga).
: FUNCTION_SET 102 DISPLAY ;

\\ : CLEAR_DISPLAY ( -- ) 101 DISPLAY;
\\ Viene utilizzata per inviare il comando CLEAR DISPLAY, che cancella il contenuto a display e pone il cursore all'inizio della
\\ prima riga
: CLEAR_DISPLAY 101 DISPLAY;

: LCD.INIT ALT0_SDA ALT0_SCL SET_SLAVE FUNCTION_SET ;


