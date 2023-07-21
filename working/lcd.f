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

\\ Toggle cursore
: CURSOR.OFF 10C DISPLAY ;
: CURSOR.BLINK.OFF 10E DISPLAY ;
: CURSOR.ON 10F DISPLAY ;

\\ : SPACE ( -- ) 20 DISPLAY ;
\\ Stampa uno spazio (ASCII = 0x20)
: SPACE 20 DISPLAY ;

\\ : STAR ( -- ) 2A DISPLAY ;
\\ Stampa un asterisco (ASCII = 0x2A)
: STAR 2A DISPLAY ;

\\ : STARS ( n --  ) BEGIN STAR 1 - DUP 0 = UNTIL DROP ;
\\ Stampa un numero di asterischi pari al valore in cima allo stack

: STARS
    BEGIN 
        STAR
        1 - DUP
    0 = UNTIL DROP ;

\\ : SPACES ( n --  ) BEGIN SPACE 1 - DUP 0 = UNTIL DROP ;
\\ Stampa un numero di spazi pari al valore in cima allo stack
: SPACES
    BEGIN 
        SPACE
        1 - DUP
    0 = UNTIL DROP ;

\\ Definizioni per la stampa di parole utili alla presentazione
\\ Richiedono l'invio di un carattere in codifica ASCII al display LCD e
\\ si tratta di una sequenza di invii di caratteri

\\ ***              ***
: STARS_ROW
    3 STARS
    E SPACES
    3 STARS ;

\\ Welcome
: WELCOME
    57 DISPLAY
    65 DISPLAY
    6C DISPLAY
    63 DISPLAY
    6F DISPLAY
    6D DISPLAY
    65 DISPLAY ;

\\ to
: TO 
    74 DISPLAY 
    6F DISPLAY ;

\\ FT
: FT 
    46 DISPLAY
    54 DISPLAY ;

\\ Project
: PROJECT 
    50 DISPLAY
    72 DISPLAY
    6F DISPLAY
    6A DISPLAY
    65 DISPLAY 
    63 DISPLAY
    74 DISPLAY ;

\\ Parola per aggregare la frase "FT Project"
: PROJ_NAME 
    FT
    SPACE
    PROJECT ;

\\ Parole per dare uno stile centrato su un display LCD_2004 per la prima parte della
\\ sequenza di avvio
: CENTER_WELCOME 
    STAR
    4 SPACES
    WELCOME SPACE TO
    4 SPACES
    STAR ;

: CENTER_PROJ_NAME
    STAR
    4 SPACES
    PROJ_NAME
    4 SPACES
    STAR ;

\\ Sequenza di stampa per la prima parte della schermata di avvio
\\ Si segue un approccio tipico della teoria delle immagini, per cui si stampa
\\ dall'alto in basso, da sinistra a destra
: START_SCREEN_1 
    FIRST_LINE DISPLAY
    STARS_ROW
    SECOND_LINE DISPLAY
    CENTER_WELCOME
    THIRD_LINE DISPLAY
    CENTER_PROJ_NAME
    FOURTH_LINE DISPLAY
    STARS_ROW ;

\\ Embedded
: EMBEDDED 
    45 DISPLAY
    6D DISPLAY
    62 DISPLAY
    65 DISPLAY
    64 DISPLAY
    64 DISPLAY
    65 DISPLAY
    64 DISPLAY ;

\\ Systems
: SYSTEMS
    53 DISPLAY
    79 DISPLAY
    73 DISPLAY
    74 DISPLAY
    65 DISPLAY
    6D DISPLAY
    73 DISPLAY ;

\\ Parola human-readable per indicare il corso
: SUBJECT 
    EMBEDDED SPACE SYSTEMS ;

\\ 2022
: Y_2022 
    32 DISPLAY
    30 DISPLAY
    32 DISPLAY
    32 DISPLAY ;

\\ 2023
: Y_2023
    32 DISPLAY
    30 DISPLAY
    32 DISPLAY
    33 DISPLAY ;

\\ A.A. 2022-2023
: COURSE.YEAR
    41 DISPLAY
    2E DISPLAY
    41 DISPLAY
    2E DISPLAY
    SPACE
    Y_2022
    2D DISPLAY
    Y_2023 ;

\\ Parole per dare uno stile centrato su un display LCD_2004 per la seconda parte della
\\ sequenza di avvio
: CENTER_SUBJECT
    STAR SPACE
    SUBJECT SPACE
    STAR ;

: CENTER_COURSE_YEAR
    STAR 2 SPACES
    COURSE.YEAR 2 SPACES
    STAR ;

\\ Sequenza di stampa per la seconda parte della schermata di avvio
: START_SCREEN_2
    SECOND_LINE DISPLAY
    CENTER_SUBJECT
    THIRD_LINE DISPLAY
    CENTER_COURSE_YEAR ;

\\ Vincenzo Fardella
: FARDELLA.NAME
    56 DISPLAY 69 DISPLAY 6E DISPLAY 63 DISPLAY 65 DISPLAY 6E DISPLAY 7A DISPLAY 6F DISPLAY 
    SPACE 
    46 DISPLAY 61 DISPLAY 72 DISPLAY 64 DISPLAY 65 DISPLAY 6C DISPLAY 6C DISPLAY 61 DISPLAY ;

\\ Matr. 0738045
: FARDELLA.ID 
    4D DISPLAY 61 DISPLAY 74 DISPLAY 72 DISPLAY 2E DISPLAY
    SPACE
    30 DISPLAY 37 DISPLAY 33 DISPLAY 38 DISPLAY 30 DISPLAY 34 DISPLAY 35 DISPLAY ;

\\ Sequenza di stampa per la terza parte della schermata di avvio
: START_SCREEN_3
    SECOND_LINE DISPLAY
    SPACE FARDELLA.NAME 2 SPACES
    THIRD_LINE DISPLAY
    3 SPACES FARDELLA.ID 4 SPACES ;

\\ Mario Tortorici
: TORTORICI.NAME
    4D DISPLAY 61 DISPLAY 72 DISPLAY 69 DISPLAY 6F DISPLAY
    SPACE
    54 DISPLAY 6F DISPLAY 72 DISPLAY 74 DISPLAY 6F DISPLAY 72 DISPLAY 69 DISPLAY 63 DISPLAY 69 DISPLAY ;

\\ Matr. 0737892
: TORTORICI.ID
    4D DISPLAY 61 DISPLAY 74 DISPLAY 72 DISPLAY 2E DISPLAY
    SPACE
    30 DISPLAY 37 DISPLAY 33 DISPLAY 37 DISPLAY 38 DISPLAY 39 DISPLAY 32 DISPLAY ;

\\ Sequenza di stampa per la terza parte della schermata di avvio
: START_SCREEN_4
    SECOND_LINE DISPLAY
    2 SPACES TORTORICI.NAME 2 SPACES
    THIRD_LINE DISPLAY
    3 SPACES TORTORICI.ID 4 SPACES ;

\\ N.B.: in START_SCREEN_2, START_SCREEN_3 e START_SCREEN_4, si è omessa la stampa della prima e della quarta riga, 
\\ in quanto queste parole sono da intendersi come parte di una presentazione, inserite in un momento
\\ in cui il contenuto di tali righe è già definitivo.

\\ Sequenza di operazioni per la presentazione iniziale del progetto, opportunamente ritardate
: START_SCREEN
    101 DISPLAY
    START_SCREEN_1
    80 MS
    START_SCREEN_2
    80 MS
    START_SCREEN_3
    80 MS
    START_SCREEN_4 
    80 MS
    101 DISPLAY ;