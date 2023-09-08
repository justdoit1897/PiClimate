<link rel="stylesheet" type="text/css" href="stili.css">

# BM - Termostato (Nome Provvisorio)

## Descrizione del progetto

Il progetto nasce per definire, in forma embrionale, un sistema di gestione del clima in ambienti chiusi, nello specifico un ambiente simile a una sala server, ossia uno in cui sono richieste specifiche condizioni ambientali per garantire il corretto funzionamento della struttura.
Il sistema target scelto è un **Raspberry&trade; Pi**, nella sua variante 1B, usato come microcontrollore per veicolare le informazioni e i calcoli da un componente all'altro.
L'obiettivo di questa prima forma del sistema è quello di permettere la visualizzazione, in modo continuato nel tempo, della condizione climatica dell'ambiente in cui ci si trova, avendo riscontro dell'eventuale presenza di valori registrati critici, e potendo interrompere il monitoraggio da input dell'utente.

## Componenti Hardware

Per la realizzazione di questo progetto, sono stati necessari:

1. 1x Raspberry&trade; Pi 1B
2. 1x Cavo USB-micro USB per l'alimentazione
3. 1x MicroSD 32GB
4. 1x Cavo USB-seriale TTL per usare l'interfaccia seriale UART
5. 1x Display LCD 2004
6. 1x Sensore Temperatura e Umidità **TZT DHT22**
7. 1x Ventola di raffreddamento a 5V 2 pin
8. 2x LED (1x LED rosso, 1x LED verde)
9. 1x Pulsante a pressione
10. Breadboard MB-102 da 400 pin

### Schema del Sistema

![Componenti e interconnessioni]()

| FUN       | DEVICE      | HEADER | PIN | PIN | HEADER | DEVICE       | FUN    |
| --------- | ----------- | ------ | --- | --- | ------ | ------------ | ------ |
|           |             | +3V3   | 1   | 2   | +5V    |              |        |
| ALT0/SDA1 | LCD2004/I2C | GPIO2  | 3   | 4   | +5V    |              |        |
| ALT0/SCL1 | LCD2004/I2C | GPIO3  | 5   | 6   | GND    | USB-SERIAL   |        |
|           |             | GPIO4  | 7   | 8   | TXD0   | USB-SERIAL   |        |
|           |             | GND    | 9   | 10  | RXD0   | USB-SERIAL   |        |
|           |             | GPIO17 | 11  | 12  | GPIO18 | DHT22/AM2302 | INPUT  |
|           |             | GPIO27 | 13  | 14  | GND    |              |        |
|           |             | GPIO22 | 15  | 16  | GPIO23 | RED LED      | OUTPUT |
|           |             | +3V3   | 17  | 18  | GPIO24 | GREEN LED    | OUTPUT |
|           |             | GPIO10 | 19  | 20  | GND    |              |        |
|           |             | GPIO9  | 21  | 22  | GPIO25 |              |        |
|           |             | GPIO11 | 23  | 24  | GPIO8  | BUTTON       | INPUT  |
|           |             | GND    | 25  | 26  | GPIO7  |              |        |

### Dispositivo Target

Come detto, il target del nostro progetto è il **Raspberry&trade; Pi 1B**. Esso monta il SoC Broadcom 2835 con processore ARM1176JZFS a 700 Mhz che, nonostante le caratteristiche non più all'avanguardia, risulta capace nella gestione dei compiti richiesti.

<img src='./images/raspberry-pi-1-modello-b.jpg' alt='Raspberry Pi 1B' width="50%">

<img src='./images/Pi-GPIO-header-26-sm.png' alt='Raspberry Pi 1B GPIO Headers' width="320" style='float:right; margin-top:120px'>

Specifiche di sistema:

* SoC Broadcom BCM2835
* CPU ARM1176JZF-S core a 700 MHz
* GPU Broadcom VideoCore IV
* 512 MB RAM
* 2 Porte USB2.0
* Video Output Composito (PAL e NTSC), HDMI o LCD diretto (DSI)
* Audio Output tramite Jack 3.5mm o Audio over HDMI
* Archiviazione: SD/MMC/SDIO
* 10/100 Ethernet (RJ45)
* Periferiche di Basso Livello:
  * 8 x GPIO
  * UART
  * bus I2C
  * bus SPI con due chip selects
  * +3.3V
  * +5V
  * massa
* Requisiti di alimentazione: 5V @ 700 mA tramite MicroUSB o Header GPIO

## Componenti Software

Per l'implementazione sono stati utilizzati:

* PC con distribuzione Linux (Ubuntu) con installato G-Forth, minicom e picocom;
* Interprete FORTH per soluzioni bare-metal pijFORTHos (via *https://github.com/organix/pijFORTHos*)

## Preparazione Ambiente di Sviluppo

Dovendo lavorare in *bare-metal*, abbiamo pensato che i file di codice dovessero essere caricati al momento sul dispositivo, per cui abbiamo optato per un trasferimento lungo la connessione seriale, sfruttando il protocollo FTDI RS-232.

Nel sistema sorgente (quello su cui viene scritto il codice da inviare), su cui deve essere installata una distribuzione Linux (nel nostro caso Ubuntu 22.04 LTS),
avviare un terminale, ed eseguire i seguenti comandi per l'installazione di G-Forth e minicom:

```bash
$ sudo apt-get update
$ sudo apt-get install -y gforth
$ sudo apt-get install -y minicom
$ sudo apt-get install -y picocom
```

Minicom è un software di emulazione di terminale per sistemi operativi Unix-like da utilizzare per stabilire una comunicazione seriale remota (con il dispositivo target). Dopo averlo installato, bisogna configurarlo con i parametri specifici per il dispositivo target:

1. Avviare l'applicativo di configurazione da terminale con il comando `$ sudo minicom -s`
2. Usando le frecce, invio (*return*) ed esc per navigare nei menu:
   1. Selezionare l'opzione "Serial port setup"
   2. Seguendo le istruzioni a schermo:
      1. Modificare il *Serial Device*, impostandolo sulla posizione del dispositivo target collegato (tipicamente `/dev/ttyUSB0`)
      2. Modificare le impostazioni relative al baud rate, al bit di parità e ai data bits necessari alla comunicazione. Per il Raspberry&trade; Pi 1B sono:
         * baud rate a 115200 bps
         * bit di parità assente
         * 8 data bits
      3. Disattivare l'opzione "Hardware Flow Control"
      4. Uscire dal menu
   3. Selezionare l'opzione "Modem and dialing"
   4. Seguendo le istruzioni a schermo
      1. Impostare i Dialing prefix e Dialing suffix (1, 2 e 3) su stringhe vuote
      2. Uscire dal menu
   5. Salvare la configurazione come di default o come nuova configurazione (es. `raspi`)
3. Uscire dall'applicativo

Dopo aver salvato la configurazione, si potrà mettere minicom in ascolto secondo i parametri scelti digitando `$ sudo minicom [nome_configurazione]`

In alternativa, è possibile utilizzare **picocom** attraverso il comando `sudo picocom -b 115200 -r -l /dev/ttyUSB0 --imap delbs -s "ascii-xfr -sv -l100 -c10"`, in cui specifichiamo:

* baudrate a 115200 bps
* `--imap delbs` per usare il backspace per cancellare caratteri
* `-s "ascii-xfr -sv -l100 -c10"` permette di specificare il protocollo ASCII-XFR per lo scambio di file, con un ritardo di 100 ms tra l'invio di una riga e l'altra e un intervallo di 10 ms tra l'invio di un carattere e l'altro.

## Preparazione della Scheda SD e dell'Interprete

Per procedere all'installazione di pijFORTHos sulla scheda SD si possono seguire direttamente le istruzioni fornite dal gestore della repo *organix*, che riportiamo per completezza.

Direttamente da Raspbian OS:

1. Aprire il terminale
2. Clonare il repository attraverso il comando `$ git clone https://github.com/organix/pijFORTHos`
3. Accedere alla posizione della copia della repository con il comando `$ cd path/to/pijFORTHos`
4. Eseguire il comando `$ make clean all`

Questa procedura genera un file `kernel.img` ma, in caso di problemi, ne può essere utilizzato uno predefinito incluso nei file della repository
Dopo di che, eseguire i comandi

```bash
$ cp firmware/* /media/<SD-card>/
$ cp kernel.img /media/<SD-card>/
```

per copiare i file necessari per pijFORTHos nella scheda SD. Alla fine della procedura la scheda conterrà esattamente tre file

```
bootcode.bin
start.elf
kernel.img
```

È possibile, quindi, inserire la scheda SD nel Raspberry&trade; Pi, connetterlo al computer con il cavo USB-seriale e, con minicom/picocom avviato secondo le modalità dette in precedenza, collegare il Raspberry&trade; Pi all'alimentazione.

## Descrizione dei Componenti

### Cavo USB-Seriale

Si tratta di un cavo con, all'interno, un convertitore USB-seriale TTL basato sul chip PL2303HX. Dispone di connettore USB tipo A da un lato e 4 fili con connettori singoli dall'altro, con pinout: filo rosso Vcc, filo nero GND, verde TXD e bianco RXD

I livelli logici di funzionamento sono 3.3V per il segnale TXD, mentre per il segnale RXD è accettato in ingresso una tensione compresa tra 3V e 5V.

È dotato di un buffer in ricezione da 128 B ed uno in trasmissione da 256 B, cosa che garantisce robustezza in trasmissioni fino a 3Mbaud/s. Collegando opportunamente il dispositivo target ad un computer dotato di ingresso USB, questo riconoscerà la connessione come una VirtualCOM Port seriale (VCP), con cui emulare la porta seriale RS232, senza bisogno di alcuna modifica.

Nel nostro caso, trattandosi di un collegamento SPI asincrono, è stato necessario specificare i parametri di sincronizzazione, come il baud rate e la dimensione (in bit) dei dati.

### Display LCD 2004 [1]

![Modulo LCD 2004](images/lcd2004/lcd2004.jpg)

Il sistema richiede l'uso di un display LCD 2004 per la presentazione delle informazioni all'utente finale ed è caratterizzato da una griglia 20 $times$ 4 di **caratteri**, ciascuno dei quali costituito da un valore standard di 5 $times$ 8 **dots**, codificati ASCII (la cui gestione da parte della ROM del modulo è visibile in figura).

![Codifica ASCII e Gestione ROM LCD 2004](images/lcd2004/ascii_lcd.png)

Il display presenta un'**interfaccia parallela** (visibile in figura) per la gestione della comunicazione con il microcontrollore, caratterizzata **da 16 pin**, utilizzata per inviare dati e/o segnali di controllo.
Nello specifico, il modello scelto, supporta anche **moduli per la serializzazione**, come quelli utilizzati nell'implementazione del protocollo I2C, per ridurre il numero di connessioni MCU-LCD e semplificare l'invio di dati completi.

![Interfaccia Parallela LCD 2004](images/lcd2004/parallel_int.png)

![Caratteristiche dei pin LCD 2004](images/lcd2004/pin_funcs.png)

### Modulo per la Serializzazione - I2C Backpack [2]

![I2C Backpack](images/i2c_backpack/module.jpeg)

Si tratta di un modulo usato tipicamente per serializzare la comunicazione tra un microcontrollore e un altro device. Nel caso specifico, il modulo si presenta nella forma di un backpack da saldare al display (nel nostro caso era già saldato) e caratterizzato da quattro pin per il collegamento con il MCU:

* due pin, rispettivamente **VCC** e **GND**, usati per l'alimentazione del modulo;
* un pin, chiamato **SDA**, per l'invio dei dati serializzati;
* un pin, chiamato **SCL**, per la sincronizzazione dei segnali di clock.

A questi, si aggiungono altri 9 pin, di cui 8 usati come bus di dati e uno usato (eventualmente) per la gestione degli interrupt inviati dal MCU.

Il modulo richiede una tensione di 5 V ed è provvisto di un potenziometro per il **controllo del contrasto** dei caratteri. Il controllo della luminosità è possibile via hardware, tramite una circuiteria *ad hoc*, o via software, tramite opportune istruzioni.

### Sensore di temperatura e umidità TZT DHT22 [3]

![Sensore di umidità e temperatura DHT22](images/dht22/module.jpeg)

Il sensore permette il monitoraggio della temperatura e dell'umidità nell'ambiente circostante, ed è caratterizzato da un sensore di base della famiglia AM2302, che si caratterizza per la capacità di gestione di segnali digitali con una precisione di &pm;0.5 °C per la temperatura e di &pm;2% RH per l'umidità, rilevando valori di temperatura tra i -40°C e i +80°C e di umidità tra lo 0% e il 100%.

Il sensore dispone di interfaccia seriale a filo singolo che ne facilita l'utilizzo. Il sensore DHT22 viene calibrato in modo estremamente preciso, essendo che i coefficienti di calibrazione sono memorizzati nella memoria OTP e vengono richiamati durante il processo di rilevamento: in questo modo non vi è alcuna necessità di ricalibrare il sensore.

La trasmissione dei dati avviene secondo uno specifico protocollo di comunicazione, suddiviso in due fasi:

1. La prima fase è quella in cui il microcontrollore invia un **segnale iniziale** al sensore, con quest'ultimo che risponde al microcontrollore.
   Dato che, inizialmente, il data bus del sensore è impostato su HIGH, la prima cosa che il microcontrollore deve fare è **abbassare** tale bus per almeno 1 ~ 10 ms (per dar modo al bus di rilevare tale comunicazione), salvo poi **rialzarlo** per 20 ~ 40 µs e **rimanere in attesa** della risposta del sensore.
   Nel momento in cui **il sensore AM2302** rileva il segnale di inizio, **abbassa** il data bus per 80 µs come risposta, salvo poi **rialzarlo** per altri 80 µs e iniziare l'effettiva trasmissione dei dati. L'intera prima fase avviene secondo un diagramma di tensione sul data bus come il seguente

   ![Fase 1 del Rilevamento AM2302](images/dht22/trans1.png)
2. La seconda fase, in cui avviene il rilevamento vero e proprio, prevede che il sensore invii **un bit per volta**, distinguendo tra 0 e 1 in base al tempo in cui il data bus viene mantenuto su HIGH dopo una fase in cui è stato tenuto LOW, sempre presente e della durata di 50 µs. Se la trasmissione del bit dura 26 ~ 28 µs, il bit trasmesso sarà uno 0, mentre, se la trasmissione durera ~ 70 µs, il bit trasmesso sarà un 1. La trasmissione di un bit segue un diagramma di tensione come i seguenti

   ![Fase 2 del Rilevamento AM2302](images/dht22/trans2.png)

I dati trasmessi ad ogni ciclo sono un totale di 40 bit, di cui i primi 16 costituenti l'**umidità relativa** (RH), i secondi sedici la **temperatura** (T) in gradi Celsius, e gli ultimi 8 bit una **checksum** per validare il rilevamento.

**N.B.** ad ogni rilevamento bisognerà seguire l'intero protocollo, dato che il sensore, senza aver ricevuto un segnale di avvio, non inizierà ad inviare dati.

La conversione da sequenza di bit a dato numerico è piuttosto semplice: basterà **dividere il valore** (espresso in base decimale) **per 10**, così da ricavare **parte intera** e **parte frazionaria** della grandezza fisica (es. `0x028C` corrisponde a 652, da cui si ricava un valore di 65.2).
Il calcolo della `sum`, in contrapposizione con la `checksum`, prevede che si separino i 32 bit misurati in byte, che si effettui la somma e che si consideri il byte finale. Se tale risultato è pari alla checksum, la trasmissione è avvenuta correttamente, altrimenti il contrario (es. `0x028C015F` produce una `sum` pari a `0xEE`).

### Bottone a Pressione

![Schema Bottone a Pressione in Pull-up](images/components/pullup.png)

Si tratta di un semplice bottone a pressione caratterizzato da **quattro pin**, per uno **switch a due poli**. Nella nostra implementazione, il pulsante è configurato in modalità **pull-up** per cui, se il pulsante è in **posizione di riposo** (non premuto), i contatti (visibili in figura) non sono connessi e **la corrente può fluire**. Alla pressione, i due poli vegono connessi, eseguendo un'**azione bloccante** rispetto alla corrente, per mandare in **reset** il sistema.

### Ventola di Raffreddamento 5V-2 pin

![Ventola di raffreddamento](images/components/cool_fan.jpg)

Si tratta di una ventola di dimensioni 60x60x10 mm, capace di lavorare a una tensione di 5V e garantire una velocità di rotazione di circa 3300 RPM, permettendo quindi un flusso d'aria di 13,8 CFM.

(*Da fare dopo aver acquistato i componenti*)

## Flusso degli Eventi

![Flusso degli Eventi](images/EventFlow.png)

Dopo aver collegato il dispositivo target all'alimentazione, aver permesso a pijFORTHos di avviarsi e aver inviato il codice da eseguire (secondo le modalità spiegate in seguito), il sistema accoglie l'utente con una scritta di benvenuto, dopo la quale effettua il primo rilevamento e stampa sul display il risultato. Successivamente, ogni *X* secondi e finché il dispositivo è alimentato, il sensore effettua rilevamenti e li mostra a schermo, in sostituzione del valore precedente.

## Codice

Nella scrittura del codice sorgente, si è provato a seguire un approccio modulare, inteso come suddiviso per aree di interesse, ma il file che deve essere trasmesso al dispositivo target dev'essere preferibilmente unico e ripulito da commenti utili solo in fase di debug, per cui abbiamo fatto ricorso ad un makefile per la generazione del file *TBD*

L'invio del file avviene attraverso minicom:

1. Avviare minicom digitando `$ sudo minicom [nome_configurazione]` da terminale
2. Premere la combinazione Ctrl+A S per aprire il prompt di invio file
3. Usando le istruzioni a schermo selezionare il protocollo di invio ASCII (per trattare il flusso di dati come un flusso di caratteri ASCII)
4. Nel menù contestuale digitare il percorso `path/to/file/TBD` del file sulla macchina sorgente (il PC Linux)
5. Attendere il caricamento del file sul Raspberry&trade; Pi e premere 'Invio'

## Descrizione dei Moduli

## Considerazioni Finali

Dopo una prima, lunga, fase di impostazione dell'attività progettuale, legata principalmente al reperimento della componentistica e all'apprendimento dell'ambiente di sviluppo (essendo la prima esperienza di programmazione a un così basso livello), possiamo affermare che la soluzione proposta rappresenti un punto di partenza per future espansioni e adattamenti a vari contesti, che vanno dalla domotica ad applicazioni industriali, in cui il rilevamento dei valori di temperatura e di umidità in tempo reale possa essere un *game-changer*.

In questo senso, possibili espansioni riguardano l'inserimento di attuatori e sensori che possano permettere alla soluzione di interfacciarsi con altri dispositivi e di fungere da regolatore del comportamento di questi ultimi, senza, peraltro, dover modificare il codice sorgente fin dove scritto: nel caso domestico, per esempio, si potrebbe pensare di centralizzare il controllo della temperatura aggiungendo pulsanti, per la determinazione dei valori desiderati, e altra componentistica, per permettere la comunicazione con le unità di controllo del clima (es. climatizzatori) e l'imposizione di tali valori fino al soddisfacimento di condizioni sia temporali che ambientali.

Inoltre, riteniamo che l'approccio seguito in fase di programmazione permetta al codice di poter essere riutilizzato anche su altri dispositivi target, semplicemente variando alcuni parametri di configurazione opportunamenti astratti.

# Bibliografia

[1] *"Specification For LCD Module 2004A"*, SHENZHEN EONE ELECTRONICS CO.,LTD
[2] *"PCF8574; PCF8574A Remote 8-bit I/O expander for I2C-bus with interrupt Rev. 5"*, NXP Semiconductors
[3] *"Digital relative humidity & temperature sensor AM2302 AM2302/DHT22"*, Liu T.
