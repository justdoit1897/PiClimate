\\ ABS ( n -- |n| )
\\ Parola usata per sostituire un numero passato in input con il suo valore assoluto
\\ 
: ABS DUP 0< IF -1 * THEN ;
\\ 
\\ BILS ( disp -- 1<<disp )
\\ Parola usata per generare un bit shiftato di un numero di posizioni passato in input
\\ 
: BILS 1 SWAP LSHIFT ;
\\  
\\ BIC ( a1 a2 -- a1&!a2 )
\\ Parola usata per eseguire un'operazione di bit-clear. Dati due valori in input, viene
\\ restituito il primo valore, in cui sono stati azzerati i bit posti a 1 del secondo valore.
\\ 
: BIC INVERT AND ;
\\ 
