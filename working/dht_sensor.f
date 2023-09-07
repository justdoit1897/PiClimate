DECIMAL
\\ Definizione di costanti legate al sensore in uso, tra cui pin GPIO di trasferimento dati,
\\ temperatura minima registrabile e temperatura massima registrabile
24 CONSTANT DHT_SENSOR
-40 CONSTANT DHT_LOW_TEMP
80 CONSTANT DHT_HIGH_TEMP
\\ SETUP_SENSOR ( dht --  )
\\ Esegue la start condition necessaria al rilevamento da parte del sensore DHT
: SETUP_SENSOR 
    DUP DUP DUP
    MODE OUTPUT 
    LOW 1 MS DELAY
    HIGH
    MODE INPUT ;
\\     
\\ WAIT_PULLDOWN ( dht --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 1 a 0 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
: WAIT_PULLDOWN BEGIN DUP PIN_LEVEL 0 = WHILE REPEAT DROP ;
\\ 
\\ WAIT_PULLUP ( dht --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 0 a 1 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
: WAIT_PULLUP BEGIN DUP PIN_LEVEL 1 = WHILE REPEAT DROP ;
\\ 
VARIABLE DATA
VARIABLE CHECKSUM
\\ READ_BIT ( -- )
\\ Viene usata per determinare se il sensore ha inviato al MCU uno 0 o un 1
\\ Calcoliamo la differenza tra il momento in cui avviene un pullup (fine dell'inizio trasmissione)
\\ e quello, precedente, in cui è avvenuto un pulldown, che dev'essere almeno di 50 (0x32) us, 
\\ la soglia che permette di affermare se è stato generato uno 0 (BASSO) o un 1 (ALTO)
: READ_BIT 
    DUP WAIT_PULLDOWN CLO_REGISTER @ SWAP WAIT_PULLUP CLO_REGISTER @ SWAP - 50 >
    IF 1 ELSE 0 THEN ;
\\ READ_DATA
\\ Viene usata per effettuare la lettura di 40 (0x28) bit per volta, conservando i primi 32 come dati effettivi,
\\ mentre gli altri 8 saranno usati come checksum
: READ_DATA 
    DUP DUP WAIT_PULLDOWN WAIT_PULLUP
    40 BEGIN
        DUP 7 > IF
            \\ Primi 32 bit per i dati
            DATA DUP @ 1 LSHIFT
        ELSE 
            \\ Ultimi 8 bit per la checksum
            CHECKSUM DUP @ 1 LSHIFT
        THEN
        3 PICK READ_BIT
        OR SWAP !
        1 - DUP 0 >
    WHILE REPEAT 2DROP ;
\\ CHECK_DATA_INTEGRITY
\\ Viene usata per verificare che i dati ricevuti non siano corrotti. Il processo
\\ prevede di dividere i dati in 4B, sommarli e confrontare gli ultimi 8 bit del 
\\ risultato con la checksum comunicata dal sensore.
: CHECK_DATA_INTEGRITY 
    DATA @ 255 AND 
    DATA @  8 RSHIFT 255 AND +
    DATA @ 16 RSHIFT 255 AND +
    DATA @ 24 RSHIFT +
    255 AND
    CHECKSUM @ = NOT IF ." Data didn't match cheksum " CR THEN ;
\\ Definiamo due variabili per contenere la parte intera e la parte frazionaria per
\\ l'umidità
VARIABLE HUMIDITY_IP
VARIABLE HUMIDITY_DP
\\ GET_HUMIDITY ( -- )
\\ Viene usata per ricavare la parte intera e la parte frazionaria dell'umidità
: GET_HUMIDITY 
    DATA @ 16 RSHIFT 10 /MOD DUP DUP 0 >= SWAP 100 <= AND
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
    DATA @ 65535 AND 10 /MOD DUP DUP DHT_LOW_TEMP >= SWAP DHT_HIGH_TEMP <= AND
    IF
        TEMPERATURE_IP !
        TEMPERATURE_DP !
    ELSE
        2DROP
    THEN ;
\\ : GET_READING ( -- ) GET_HUMIDITY GET_TEMPERATURE ;
\\ Parola comprensiva per ricavare i valori intero e decimale di temperatura e umidità
: GET_READING GET_HUMIDITY GET_TEMPERATURE ;
\\ : HUMIDITY>CMD DECIMAL ." Humidity: " HUMIDITY_IP ? ." . " HUMIDITY_DP ? ." %" ;
\\ Parola usata per stampare su riga di comando il valore di umidità ricavato
: HUMIDITY>CMD ." Humidity: " HUMIDITY_IP ? ." . " HUMIDITY_DP ? ." %" ;
\\ : TEMPERATURE>CMD DECIMAL ." Temperature: " TEMPERATURE_IP ? ." . " TEMPERATURE_DP ? ." °C" ;
\\ Parola usata per stampare su riga di comando il valore di temperatura ricavato
: TEMPERATURE>CMD ." Temperature: " TEMPERATURE_IP ? ." . " TEMPERATURE_DP ? ." °C" ;
\\ : DHT>CMD DECIMAL TEMPERATURE>CMD ."  - " HUMIDITY>CMD CR ;
\\ Parola comprensiva usata per stampare su riga di comando sia la temperatura che l'umidità ricavate
: DHT>CMD TEMPERATURE>CMD ."  - " HUMIDITY>CMD CR ;
\\ : MEASURE ( dht -- ) 0 DATA ! 0 CHECKSUM ! SETUP_SENSOR READ_DATA GET_READING DHT>CMD ;
\\ Parola principale per le operazioni di un sensore passato in input. Ogni misurazione andrà separata
\\ dall'altra di almeno 2 secondi.
: MEASURE 0 DATA ! 0 CHECKSUM ! DUP SETUP_SENSOR READ_DATA GET_READING DHT>CMD ;
