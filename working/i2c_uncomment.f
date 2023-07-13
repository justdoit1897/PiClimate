HEX
20000000 CONSTANT BASE
BASE 200000 + CONSTANT GPFSEL0

BASE 804000 + CONSTANT I2C_BASE
I2C_BASE 0 + CONSTANT C_REGISTER
I2C_BASE 8 + CONSTANT DLEN_REGISTER
I2C_BASE C + CONSTANT A_REGISTER
I2C_BASE 10 + CONSTANT FIFO_REGISTER

27 CONSTANT SLAVE_ADDRESS

: DELAY BEGIN 1 - DUP 0 = UNTIL DROP ;

: MS 1000 * DELAY ;

: ALT0_SDA GPFSEL0 DUP @ 100 XOR SWAP ! ;

: ALT0_SCL GPFSEL0 DUP @ 800 XOR SWAP ! ;

: SET_DLEN 1 DLEN_REGISTER ! ;

: SET_SLAVE SLAVE_ADDRESS A_REGISTER ! ;

: >FIFO FIFO_REGISTER ! ;

: START_TRANSFER 8080 C_REGISTER ! ;

: TO_I2C
    >FIFO
    SET_DLEN
    START_TRANSFER ;

: SEND_NIBBLE 
    DUP ROT 
    IF C +
    ELSE D +
    THEN
    TO_I2C 1 MS
    8 + TO_I2C 2 MS ;

: SEND_BYTE
    2DUP F0 AND SEND_NIBBLE 
    F AND 4 LSHIFT SEND_NIBBLE 5 MS ;

: IS_CMD DUP 8 RSHIFT 1 = ;

: DISPLAY IS_CMD SWAP SEND_BYTE ;

: FUNCTION_SET 102 DISPLAY ;

: LCD.INIT ALT0_SDA ALT0_SCL SET_SLAVE FUNCTION_SET ;
