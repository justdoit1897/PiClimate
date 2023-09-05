\\ Definizione di costanti legate al sensore in uso, tra cui pin GPIO di trasferimento dati,
\\ temperatura minima registrabile e temperatura massima registrabile
10# 24 CONSTANT DHT_SENSOR
10# -40 CONSTANT DHT_LOW_TEMP
10# 80 CONSTANT DHT_HIGH_TEMP
\\ SETUP_SENSOR ( dht --  )
\\ Esegue la start condition necessaria al rilevamento da parte del sensore DHT
: SETUP_SENSOR 
    DECIMAL 
    DUP DUP DUP
\\    ." RPi: GPIO pin " DHT_SENSOR DUP . ." level at begin = " PIN_LEVEL . CR
    MODE OUTPUT 
\\    ." RPi: GPIO pin " DHT_SENSOR DUP . ." level after set output mode = " PIN_LEVEL . CR
    LOW 1000 DELAY
\\    ." RPi: GPIO pin " DHT_SENSOR DUP . ." level after set low = " PIN_LEVEL . CR
    HIGH
\\    ." RPi: GPIO pin " DHT_SENSOR DUP . ." level after set high = " PIN_LEVEL . CR
    MODE INPUT
\\    ." RPi: GPIO pin " DHT_SENSOR DUP . ." level after set input mode = " PIN_LEVEL . CR 
    HEX ;
\\     
\\ WAIT_PULLDOWN ( dht --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 1 a 0 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
: WAIT_PULLDOWN BEGIN DHT_SENSOR PIN_LEVEL 0 = WHILE REPEAT ;
\\ 
\\ WAIT_PULLUP ( dht --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 0 a 1 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
: WAIT_PULLUP BEGIN DHT_SENSOR PIN_LEVEL 1 = WHILE REPEAT ;
\\ 
VARIABLE DATA
VARIABLE CHECKSUM
\\ READ_BIT ( -- )
\\ Viene usata per determinare se il sensore ha inviato al MCU uno 0 o un 1
\\ Calcoliamo la differenza tra il momento in cui avviene un pullup (fine dell'inizio trasmissione)
\\ e quello, precedente, in cui è avvenuto un pulldown, che dev'essere almeno di 50 (0x32) us, 
\\ la soglia che permette di affermare se è stato generato uno 0 (BASSO) o un 1 (ALTO)
: READ_BIT 
    WAIT_PULLDOWN CLO_REGISTER @ WAIT_PULLUP CLO_REGISTER @ SWAP - 32 >
    IF 1 ELSE 0 THEN ;
\\ READ_DATA
\\ Viene usata per effettuare la lettura di 40 (0x28) bit per volta, conservando i primi 32 come dati effettivi,
\\ mentre gli altri 8 saranno usati come checksum
: READ_DATA 
    WAIT_PULLDOWN WAIT_PULLUP
    28 BEGIN
        DUP 7 > IF
            \\ Primi 32 bit per i dati
            DATA DUP @ 1 LSHIFT
            READ_BIT
            OR SWAP !
        ELSE 
            \\ Ultimi 8 bit per la checksum
            CHECKSUM DUP @ 1 LSHIFT
            READ_BIT
            OR SWAP !
        THEN
        1 - DUP 0 >
    WHILE REPEAT DROP ;
\\ CHECK_DATA_INTEGRITY
\\ Viene usata per verificare che i dati ricevuti non siano corrotti. Il processo
\\ prevede di dividere i dati in 4B, sommarli e confrontare gli ultimi 8 bit del 
\\ risultato con la checksum comunicata dal sensore.
: CHECK_DATA_INTEGRITY 
    DATA @ FF AND 
    DATA @  8 RSHIFT FF AND +
    DATA @ 10 RSHIFT FF AND +
    DATA @ 18 RSHIFT +
    FF AND
    CHECKSUM @ = NOT IF ." Data didn't match cheksum " CR THEN ;
\\ Definiamo due variabili per contenere la parte intera e la parte frazionaria per
\\ l'umidità
VARIABLE HUMIDITY_IP
VARIABLE HUMIDITY_DP
\\ GET_HUMIDITY ( -- )
\\ Viene usata per ricavare la parte intera e la parte frazionaria dell'umidità
: GET_HUMIDITY 
    DATA @ 10 RSHIFT A /MOD DUP DUP 0 >= SWAP 64 <= AND
    IF
        HUMIDITY_IP ! 
        HUMIDITY_DP ! 
    ELSE
        2DROP
    THEN ;
\\ Definiamo due variabili per contenere la parte intera e la parte frazionaria per
\\ la temperatura
VARIABLE TEMPERATURE_IP
VARIABLE TEMPERATURE_DP
\\ GET_TEMPERATURE ( -- )
\\ Viene usata per ricavare la parte intera e la parte frazionaria dell'umidità
: GET_TEMPERATURE 
    DATA @ FFFF AND A /MOD DUP DUP DHT_LOW_TEMP >= SWAP DHT_HIGH_TEMP <= AND
    IF
        TEMPERATURE_IP !
        TEMPERATURE_DP !
    ELSE
        2DROP
    THEN ;
\\ : GET_READING ( -- ) GET_HUMIDITY GET_TEMPERATURE ;
\\ Parola comprensiva per ricavare i valori intero e decimale di temperatura e umidità
: GET_READING GET_HUMIDITY GET_TEMPERATURE ;
\\ : HUMIDITY>CMD DECIMAL ." Humidity: " HUMIDITY_IP ? ." . " HUMIDITY_DP ? ." %" HEX ;
\\ Parola usata per stampare su riga di comando il valore di umidità ricavato
: HUMIDITY>CMD DECIMAL ." Humidity: " HUMIDITY_IP ? ." . " HUMIDITY_DP ? ." %" HEX ;
\\ : TEMPERATURE>CMD DECIMAL ." Temperature: " TEMPERATURE_IP ? ." . " TEMPERATURE_DP ? ." °C" HEX ;
\\ Parola usata per stampare su riga di comando il valore di temperatura ricavato
: TEMPERATURE>CMD DECIMAL ." Temperature: " TEMPERATURE_IP ? ." . " TEMPERATURE_DP ? ." °C" HEX ;
\\ : DHT>CMD DECIMAL TEMPERATURE>CMD ."  - " HUMIDITY>CMD CR HEX ;
\\ Parola comprensiva usata per stampare su riga di comando sia la temperatura che l'umidità ricavate
: DHT>CMD DECIMAL TEMPERATURE>CMD ."  - " HUMIDITY>CMD CR HEX ;
\\ : MEASURE ( dht -- ) 0 DATA ! 0 CHECKSUM ! SETUP_SENSOR READ_DATA GET_READING DHT>CMD ;
\\ Parola principale per le operazioni di un sensore passato in input. Ogni misurazione andrà separata
\\ dall'altra di almeno 2 secondi.
: MEASURE 0 DATA ! 0 CHECKSUM ! SETUP_SENSOR READ_DATA GET_READING DHT>CMD ;
