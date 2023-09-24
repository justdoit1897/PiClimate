DECIMAL
\\ 
\\ Definizione di costanti legate al sensore in uso, tra cui umidità minima, umidità massima,
\\ temperatura minima e temperatura massima registrabili
\\ 
-40                 CONSTANT MIN_TEMP
80                  CONSTANT MAX_TEMP
0                   CONSTANT MIN_HUM
100                 CONSTANT MAX_HUM
\\ 
\\ Definizione di variabili usate per contenere i dati raccolti
\\ 
\\ Dati e checksum
VARIABLE DATA
VARIABLE CHECKSUM
\\ 
\\ Parti intere e parti decimali di umidità e temperatura
\\ 
VARIABLE HUMIDITY_IP
VARIABLE HUMIDITY_DP
VARIABLE TEMPERATURE_IP
VARIABLE TEMPERATURE_DP
\\ 
\\ Definizione di costanti legate alla connessione sensore-microcontrollore, nello specifico
\\ maschera di FSEL per il pin in uso, valore da scrivere in GPFSEL per il pin in uso e per le 
\\ modalità input e output e registro GPFSEL associato al pin in uso.
\\ 
GPIO18 FSEL          CONSTANT GPIO18_FSEL
GPIO18 OUT MODE      CONSTANT GPIO18_OUT
GPIO18 INP MODE      CONSTANT GPIO18_INP
GPIO18 GPFSEL        CONSTANT GPIO18_GPFSEL
\\ 
\\ WAIT_PULLDOWN ( n_gpio --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 1 a 0 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
\\ 
: WAIT_PULLDOWN 
    BEGIN 
        DUP PIN_LEVEL 
        0 = WHILE 
    REPEAT 
    DROP ;
\\
\\ WAIT_PULLUP ( n_gpio --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 0 a 1 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
\\ 
: WAIT_PULLUP 
    BEGIN 
        DUP PIN_LEVEL 
        1 = WHILE 
    REPEAT 
    DROP ;
\\  
\\ DHT_PIN_OUT ( -- )
\\ Scorciatoia per settare i parametri utili ad impostare la FSEL per il pin utilizzato in modalità output
\\ 
: DHT_PIN_OUT GPIO18_FSEL GPIO18_OUT GPIO18_GPFSEL ;
\\ 
\\ DHT_OUT ( -- )
\\ Imposta il pin in modalità output
\\ 
: DHT_OUT DHT_PIN_OUT ENABLE_PIN ;
\\  
\\ DHT_PIN_INP ( -- )
\\ Scorciatoia per settare i parametri utili ad impostare la FSEL per il pin utilizzato in modalità input
\\ 
: DHT_PIN_INP GPIO18_FSEL GPIO18_INP GPIO18_GPFSEL ;
\\ 
\\ DHT_INPUT ( -- )
\\ Imposta il pin in modalità input
\\ 
: DHT_INPUT DHT_PIN_INP ENABLE_PIN ;
\\ SETUP_SENSOR (  --  )
\\ Esegue le istruzioni necessarie a mandare lo start signal al sensore, necessario al rilevamento da parte di
\\ quest'ultimo. Nello specifico:
\\ - imposta il pin in output mode
\\ - attiva il bit associato al pin nel GPCLR opportuno e attende 1 ms
\\ - attiva il bit associato al pin nel GPSET opportuno
\\ - imposta il pin in input mode
\\ 
: SETUP_SENSOR 
    DHT_OUT
    GPIO18 DUP GPCLR !
    1 MILLISECONDS CLK_DELAY
    GPIO18 DUP GPSET !
    DHT_INPUT ;
\\ 
\\ READ_BIT ( -- )
\\ Viene usata per determinare se il sensore ha inviato al MCU uno 0 o un 1.
\\ Calcoliamo la differenza tra il momento in cui avviene un pullup (fine dell'inizio trasmissione)
\\ e quello, precedente, in cui è avvenuto un pulldown, che dev'essere almeno di 50 us, 
\\ la soglia che permette di affermare se è stato trasmesso uno 0 o un 1.
\\ 
: READ_BIT DUP WAIT_PULLDOWN TIMER_COUNT @ SWAP WAIT_PULLUP TIMER_COUNT @ SWAP - 50 > IF 1 ELSE 0 THEN ;
\\
\\ READ_DATA ( -- )
\\ Viene usata per effettuare la lettura di 40 bit per volta, conservando i primi 32 come dati effettivi nella
\\ variabile DATA, mentre gli altri 8 saranno usati come checksum nella variabile omonima.
\\ 
: READ_DATA 
    GPIO18 N_GPIO DUP DUP DUP WAIT_PULLDOWN WAIT_PULLUP
    39 BEGIN
        DUP 7 > IF
            DATA DUP @ 1 LSHIFT
        ELSE 
            CHECKSUM DUP @ 1 LSHIFT
        THEN
        3 PICK READ_BIT
        OR SWAP !
        1 - DUP 0 >
    WHILE REPEAT 2DROP ;
\\ 
\\ GET_HUMIDITY ( -- )
\\ Viene usata per ricavare la parte intera e la parte frazionaria dell'umidità dalla variabile DATA
\\ 
: GET_HUMIDITY 
    DATA @ 16 RSHIFT 10 /MOD DUP DUP MIN_HUM >= SWAP MAX_HUM <= AND
    IF
        HUMIDITY_IP ! 
        HUMIDITY_DP ! 
    ELSE
        2DROP
    THEN ;
\\ 
\\ GET_TEMPERATURE ( -- )
\\ Viene usata per ricavare la parte intera e la parte frazionaria della temperatura dalla variabile DATA
\\ 
: GET_TEMPERATURE 
    DATA @ 65535 AND 10 /MOD DUP DUP MIN_TEMP >= SWAP MAX_TEMP <= AND
    IF
        TEMPERATURE_IP !
        TEMPERATURE_DP !
    ELSE
        2DROP
    THEN ;
\\ 
\\ GET_READING ( -- )
\\ Parola comprensiva per ricavare i valori interi e decimali di temperatura e umidità
\\ 
: GET_READING GET_HUMIDITY GET_TEMPERATURE ;
\\ 
\\ HUMIDITY>CMD ( -- )
\\ Parola usata per stampare su riga di comando il valore di umidità ricavato
\\ 
: HUMIDITY>CMD ." Humidity: " HUMIDITY_IP ? ." . " HUMIDITY_DP ? ." %" ;
\\
\\ INT_MSG ( r q x -- )
\\ Parola usata per stampare su schermo la parte intera di un valore (temperatura/umidità)
\\ 
: INT_MSG 13 SET_CURSOR NUMBER >LCD NUMBER >LCD ;
\\
\\ DEC_MSG ( n x -- )
\\ Parola usata per stampare su schermo la parte decimale di un valore (temperatura/umidità)
\\ 
: DEC_MSG 16 SET_CURSOR NUMBER >LCD ;
\\ 
\\ HUMIDITY>LCD ( -- )
\\ Parola usata per stampare su display LCD il valore di umidità ricavato
\\ 
: HUMIDITY>LCD 
    HUMIDITY_IP @ 10 /MOD ROW3 INT_MSG
    HUMIDITY_DP @ ROW3 DEC_MSG ;
\\  
\\ TEMPERATURE>CMD ( -- )
\\ Parola usata per stampare su riga di comando il valore di temperatura ricavato
\\ 
: TEMPERATURE>CMD ." Temperature: " TEMPERATURE_IP ? ." . " TEMPERATURE_DP ? ." *C" ;
\\ 
\\ TEMPERATURE>LCD ( -- )
\\ Parola usata per stampare su display LCD il valore di temperatura ricavato
\\ 
: TEMPERATURE>LCD 
    TEMPERATURE_IP @ 10 /MOD ROW2 INT_MSG
    TEMPERATURE_DP @ ROW2 DEC_MSG ;
\\ 
\\ DHT>CMD ( -- )
\\ Parola comprensiva per stampare su riga di comando i valori di temperatura e di umidità ricavati
\\ 
: DHT>CMD TEMPERATURE>CMD ."  - " HUMIDITY>CMD CR ;
\\ 
\\ MEASURE ( -- )
\\ Parola comprensiva per l'esecuzione dell'intero processo per una singola misurazione del sensore
\\ 
: MEASURE 0 DATA ! 0 CHECKSUM ! SETUP_SENSOR READ_DATA GET_READING DHT>CMD DROP ;

: DHT_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." dht.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE main.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

DHT_OK
