\\ 
HEX
\\ 
20000000 CONSTANT BASE
\\ 
BASE 200000 + CONSTANT GPFSEL0
BASE 200004 + CONSTANT GPFSEL1
BASE 200008 + CONSTANT GPFSEL2
\\ 
BASE 20001C + CONSTANT GPSET0
\\ 
BASE 200028 + CONSTANT GPCLR0
\\ 
BASE 200034 + CONSTANT GPLEV0
\\ 
BASE 200040 + CONSTANT GPEDS0
\\ 
BASE 200058 + CONSTANT GPFEN0
\\ 
BASE 20007C + CONSTANT GPAREN0
\\ 
\\ : 2* ( n -- 1<<n ) 1 SWAP LSHIFT ;
\\ Restituisce 1 shiftato a sinistra di un numero di posizioni passato in input
: 2* 1 SWAP LSHIFT ;
\\ 
\\ MODE ( pin -- R V B) R -> GPFSEL_REGISTER_ADDR; V -> REGISTER_VAL B -> DISPLACEMENT_BIT
\\ Restituisce l'indirizzo del registro GPFSEL, il valore del registro e il primo bit della
\\ tripla che regola la FSEL per il pin passato in input
\\ ES: 24 -- 20200008 8 12
: MODE A /MOD 4 * GPFSEL0 + SWAP 3 * DUP 7 SWAP LSHIFT ROT DUP @ ROT INVERT AND ROT ;
\\ 
\\ : INPUT ( R V B --  ) 2* INVERT AND SWAP ! ;
\\ *** Da usare successivamente a MODE ***
\\ Imposta la tripletta di bit che regola la FSEL di un pin passato in input a MODE su 000
\\ corrispondente alla FSEL Input
: INPUT 2* INVERT AND SWAP ! ;
\\
\\ : OUTPUT ( R V B --  ) 2* XOR SWAP ! ;
\\ *** Da usare successivamente a MODE ***
\\ Imposta la tripletta di bit che regola la FSEL di un pin passato in input a MODE su 001
\\ corrispondente alla FSEL Output
: OUTPUT 2* XOR SWAP ! ;
\\ 
\\ : GET_GPSET ( pin -- gpset ) 20 / 4 * GPSET0 + ;
\\ Restituisce il registro GPSET (0 o 1) associato ad un pin passato in input
: GET_GPSET 20 / 4 * GPSET0 + ;
\\ 
\\ : HIGH ( pin --  ) DUP 20 MOD 2* SWAP GET_GPSET ! ;
\\ Imposta ad 1 il bit del relativo registro GPSET associato ad un pin passato in input
: HIGH DUP 20 MOD 2* SWAP GET_GPSET ! ;
\\ 
\\ : GET_GPCLR ( pin -- gpclr ) 20 / 4 * GPCLR0 + ;
\\ Restituisce il registro GPCLR (0 o 1) associato ad un pin passato in input
: GET_GPCLR 20 / 4 * GPCLR0 + ;
\\ 
\\ : LOW ( pin --  ) DUP 20 MOD 2* SWAP GET_GPSET ! ;
\\ Imposta ad 1 il bit del relativo registro GPCLR associato ad un pin passato in input
: LOW DUP 20 MOD 2* SWAP GET_GPCLR ! ;
\\ 
\\ : GET_GPLEV ( pin -- gplev ) 20 / 4 * GPSET0 + ;
\\ Restituisce il registro GPLEV (0 o 1) associato ad un pin passato in input
: GET_GPLEV 20 / 4 * GPLEV0 + ;
\\
\\ : PIN_LEVEL ( pin -- plev ) DUP GET_GPLEV @ SWAP 20 MOD 1 SWAP LSHIFT AND 1 IF 1 ELSE 0 THEN ;
\\ Restituisce il livello (H o L) di un pin passato in input
: PIN_LEVEL DUP GET_GPLEV @ SWAP 20 MOD 1 SWAP LSHIFT AND IF 1 ELSE 0 THEN ;
\\ 