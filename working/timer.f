\\ 
\\ Per avere una gestione dei tempi quanto più real-time, usiamo il System Timer del RPi.
\\ È dotato di quattro registri a 32-bit (canali) per la gestione del tempo ed un contatore a 64-bit
\\ Ognuno dei canali è associato ad un registro di confronto dell'output, usato per un confronto con
\\ i 32 bit meno significativi del contatore. Quando i due valori coincidono, il System Timer genera un segnale
\\ che indica l'avvenuta coincidenza per un certo canale, passato in input al controller per gli interrupt
\\ L'indirizzo fisico (hardware) del System Timer per quest'implementazione è 0x20003000
BASE 3000 + CONSTANT SYSTEM_TIME_BASE
SYSTEM_TIME_BASE 4 + CONSTANT CLO_REGISTER
\\ 
\\ : DELAY ( us --  ) CLO_REGISTER @ BEGIN 2DUP CLO @ - ABS SWAP > UNTIL 2DROP ;
\\ Pone il sistema in busy-wait per un certo numero di microsecondi passato in input
: DELAY CLO_REGISTER @ BEGIN 2DUP CLO_REGISTER @ - ABS SWAP > UNTIL 2DROP ;
\\ 
