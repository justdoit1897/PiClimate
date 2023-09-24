
DECIMAL

: SETUP 
    INIT_I2C
    INIT_LCD
    INIT_LEDS
    INIT_BTN ;

: MAIN
    BEGIN
        MEASURE
        TEMPERATURE_IP @ 20 32 WITHIN HUMIDITY_IP @ 40 90 WITHIN AND 
        TRUE =  IF
            TEMP_HUM_MSG
            TEMPERATURE>LCD HUMIDITY>LCD
            GREEN LED OFF
        ELSE 
            TEMPERATURE_IP @ 20 <= IF 
                LOW_TEMP_MSG
                3 BLINK
            ELSE TEMPERATURE_IP @ 32 >= IF
                HIGH_TEMP_MSG
                5 BLINK
                GREEN LED ON
                THEN
            THEN 
            HUMIDITY_IP @ 40 <= IF
                LOW_HUM_MSG
                4 BLINK
            ELSE HUMIDITY_IP @ 90 >= IF
                HIGH_HUM_MSG
                6 BLINK
                THEN
            THEN
        THEN
        2 SECONDS CLK_DELAY
        RESET_BTN IS_CLICKED TRUE =
    UNTIL ;

: MAIN_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." main.f CARICATO CORRETTAMENTE" CR 
        ." DIGITARE COMANDO 'MAIN' SUL TERMINALE PER AVVIARE IL SISTEMA" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

MAIN_OK

SETUP                                                               1 SECONDS DELAY
MAIN

