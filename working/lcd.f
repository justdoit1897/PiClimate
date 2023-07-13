\\ Da caricare dopo i2c.f e lut.f

\\ Costanti

180 CONSTANT FIRST_LINE
1C0 CONSTANT SECOND_LINE
FIRST_LINE 14 + CONSTANT THIRD_LINE
SECOND_LINE 14 + CONSTANT FOURTH_LINE

\\ Shift D/S cursore
: CURSOR.RSHIFT 114 DISPLAY ;
: CURSOR.LSHIFT 110 DISPLAY ;

\\ Ritorna all'inizio della riga
: HOME 102 DISPLAY ;

\\ Toggle cursore lampeggiante
: CURSOR.OFF 10E DISPLAY ;
: CURSOR.ON 10F DISPLAY ;

\\ N.B.: La distanza tra gli indirizzi di due posizioni consecutive è 1, quindi non è così necessario
\\ Fare diversi shift