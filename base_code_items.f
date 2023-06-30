\ Le parole contenute in questo file possono essere utilizzate come base per 
\ definire cicli e operazioni condizionali

\ operazioni condizionali

: IF-THEN-ELSE ( condition -- )
  \ qui la condizione in input viene valutata ed effettua il branching
  IF
    \ condizione vera
    CR ." Condizione vera "
  ELSE
    \ condizione falsa
    CR ." Condizione falsa "
  THEN ;

\ cicli

\ in generale, un ciclo for si implementa come ripetizione del codice tra le
\ parole DO e WHILE, ponendo in mezzo il codice dell'iterazione

: FOR ( from to -- )
  1+ SWAP \ incrementa il limite superiore e scambia gli estremi
  DO
    \ codice da eseguire in loop (per adesso stampa solo "Iterazione: X")
    CR  ." Iterazione  " I .  
  LOOP ;

\ il ciclo while si può implementare in più modi, quello che c'è scritto qui
\ è in logica negativa, nel senso che si esegue del codice finché non si verifica
\ una condizione. Il flusso di lavoro, quindi, è il seguente:
\
\   BEGIN codice_valutazione_flag WHILE codice_da_eseguire REPEAT
\

: WHILE ( limit -- ) 
  BEGIN
    \ codice da eseguire come corpo del while
  WHILE
    \ condizione di continuazione
  REPEAT ; 


\ esempi
\ esempio 1: adattare il ciclo for per riempire lo stack di un certo numero di valori;

: ADD-NUMBERS ( from to -- )  1+ SWAP  DO  I  LOOP ;

\ esempio 2: adattare il ciclo while per stampare i valori presenti sullo stack;

: WHILE-STACK-NOT-EMPTY ( -- ) BEGIN DUP 0= NOT WHILE DUP . CR 1- REPEAT ;
