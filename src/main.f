
DECIMAL

: MAIN
    INIT_I2C
    INIT_LCD
    INIT_FAN
    INIT_LEDS
    INIT_BTN
    TEMP_HUM_MSG
    BEGIN
        MEASURE
        TEMPERATURE_IP 20 24 WITHIN HUMIDITY_IP 40 60 WITHIN AND 
        TRUE =  IF
            TEMPERATURE>LCD HUMIDITY>LCD
            GREEN LED OFF
        ELSE 
            TEMPERATURE_IP 20 < IF 
                LOW_TEMP_MSG
                3 BLINK
            ELSE TEMPERATURE_IP 24 > IF
                HIGH_TEMP_MSG
                5 BLINK
                GREEN LED ON
            THEN 
            HUMIDITY_IP 40 < IF
                LOW_HUM_MSG
                4 BLINK
            ELSE HUMIDITY_IP 60 > IF
                HIGH_HUM_MSG
                6 BLINK
            THEN
            TEMP_HUM_MSG
        THEN
        2 SECONDS DELAY
        RESET_BTN
    UNTIL IS_PRESSED ;

: MAIN_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." main.f CARICATO CORRETTAMENTE" CR 
        ." DIGITARE COMANDO START SUL TERMINALE PER AVVIARE IL SISTEMA" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

MAIN_OK
