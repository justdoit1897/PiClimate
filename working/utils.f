\\ File per parole di utilità nell'implelentazione del sistema
\\ 
DECIMAL
\\ : MS ( n -- msecs ) 1000 * ;
\\ Restituisce un numero di microsecondi corrispondenti ai millisecondi passati in input
: MS 1000 * ;
\\ : SECS ( n -- secs ) 1000 * MS ;
\\ Restituisce un numero di microsecondi corrispondenti ai secondi passati in input
: SECS 1000 * MS ;
\\ : ABS ( n -- |n| ) DUP 0< IF -1 * THEN ;
\\ Restituisce il valore assoluto di un numero passato in input
: ABS DUP 0< IF -1 * THEN ;
\\ 