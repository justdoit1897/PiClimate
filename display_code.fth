: COLORA-PIXEL ( x y col -- ) 
  \ colora il pixel (x,y) del colore col
  \ controlliamo che col sia maggiore di 0, dato che lavoriamo in bianco e nero (0-255)
  0 >
  IF
      \ colora il pixel (x,y) di bianco (255)
      255 SET-PIXEL
  ELSE
      \ colora il pixel (x,y) di nero (0)
      0 SET-PIXEL
  THEN ;

: SET-PIXEL ( x y col -- )
  \ usando l'interfaccia GPIO, utilizzo un pin per controllare il pixel
  \ es. supponiamo che il pin di controllo sia il 2
  
 ;