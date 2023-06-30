# BM - Termostato (Nome Provvisorio)

## Descrizione del progetto

Il progetto nasce per definire, in forma embrionale, un sistema di gestione del clima in ambienti chiusi. Il sistema target scelto è un **Raspberry&trade; Pi**, nella sua variante 1B, attraverso cui viene visualizzata, in modo continuato nel tempo, la condizione climatica dell'ambiente in cui ci si trova.

## Componenti Hardware

Per la realizzazione di questo progetto, sono stati necessari:
1. Raspberry&trade; Pi 1B
2. Cavo USB-micro USB per l'alimentazione
3. MicroSD 32GB
4. Cavo USB-seriale TTL per usare l'interfaccia seriale UART
5. Display (*TBD*)
6. Sensore Temperatura e Umidità (*TBD*)
7. Breadboard (*TBD*)

### Schema del Sistema

![Componenti e interconnessioni]()

| FUN | CONN | HEADER | PIN | PIN | HEADER  | CONN | FUN |
| --- | ---  |  ---   | --- | --- |  ---    | ---  | --- |
|     |      |        |  1  |  2  |         |      |     |
|     |      |        |  3  |  4  |         |      |     |
|     |      |        |  5  |  6  |   GND   |      |     |
|     |      |        |  7  |  8  | UART TX | TXD  |     |
|     |      |        |  9  | 10  | UART RX | RXD  |     |
|     |      |        | 11  | 12  |         |      |     |
|     |      |        | 13  | 14  |         |      |     |
|     |      |        | 15  | 16  |         |      |     |
|     |      |        | 17  | 18  |         |      |     |
|     |      |        | 19  | 20  |         |      |     |
|     |      |        | 21  | 22  |         |      |     |
|     |      |        | 23  | 24  |         |      |     |
|     |      |        | 25  | 26  |         |      |     |

### Dispositivo Target

Come detto, il target del nostro progetto è il Raspberry&trade; Pi 1B. Esso monta il SoC Broadcom 2835 con processore ARM1176JZFS a 700 Mhz che, nonostante le caratteristiche non più all'avanguardia, si dimostra particolarmente potente nella gestione dei compiti richiesti.

<img src='./images/raspberry-pi-1-modello-b.jpg' alt='Raspberry Pi 1B' width="640">

<img src='./images/Pi-GPIO-header-26-sm.png' alt='Raspberry Pi 1B GPIO Headers' width="320" style='float:right;'>

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
* PC con distribuzione Linux (Ubuntu) con installato G-Forth e minicom;
* Interprete FORTH per soluzioni bare-metal pijFORTHos (via *https://github.com/organix/pijFORTHos*)

## Preparazione Ambiente di Sviluppo

Dovendo lavorare in *bare-metal*, abbiamo pensato che i file di codice dovessero essere caricati al momento sul dispositivo, per cui abbiamo optato per un trasferimento lungo la connessione seriale, sfruttando il protocollo FTDI RS-232.

Nel sistema sorgente (quello su cui viene scritto il codice da inviare), su cui deve essere installata una distribuzione Linux (nel nostro caso Ubuntu 22.04 LTS), 
avviare un terminale, ed eseguire i seguenti comandi per l'installazione di G-Forth e minicom:

```
$ sudo apt-get update
$ sudo apt-get install -y gforth
$ sudo apt-get install -y minicom
```

Minicom è un software di emulazione di terminale per sistemi operativi Unix-like da utilizzare per stabilire una comunicazione seriale remota (con il dispositivo target). Dopo averlo installato, bisogna configurarlo con i parametri specifici per il dispositivo target:
1. Avviare l'applicativo di configurazione da terminale con il comando `$ sudo minicom -s`
2. Usando le frecce, invio (*return*) ed esc per navigare nei menu:
   1. Selezionare l'opzione "Serial port setup"
   2. Seguendo le istruzioni a schermo:
      1. Modificare il *Serial Device*, impostandolo sulla posizione del dispositivo target collegato (tipicamente `/dev/ttyUSB0`)
      2. Modificare le impostazioni relative al baud rate, al bit di parità e ai data bits necessari alla comunicazione. Per il Raspberry&trade; Pi 1B sono:
          * baud rate a 115200 data/s
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

## Preparazione della Scheda SD e dell'Interprete

Per procedere all'installazione di pijFORTHos sulla scheda SD si possono seguire direttamente le istruzioni fornite dal gestore della repo *organix*, che riportiamo per completezza.

Direttamente da Raspbian OS:
1. Aprire il terminale
2. Clonare il repository attraverso il comando `$ git clone https://github.com/organix/pijFORTHos`
3. Accedere alla posizione della copia della repository con il comando `$ cd path/to/pijFORTHos`
4. Eseguire il comando `$ make clean all`

Questa procedura genera un file `kernel.img` ma, in caso di problemi, ne può essere utilizzato uno predefinito incluso nei file della repository
Dopo di che, eseguire i comandi

```
$ cp firmware/* /media/<SD-card>/
$ cp kernel.img /media/<SD-card>/
```

per copiare i file necessari per pijFORTHos nella scheda SD. Alla fine della procedura la scheda conterrà esattamente tre file

```
bootcode.bin
start.elf
kernel.img
```

È possibile, quindi, inserire la scheda SD nel Raspberry&trade; Pi, connetterlo al computer con il cavo USB-seriale e, con minicom avviato secondo le modalità dette in precedenza, collegare il Raspberry&trade; Pi all'alimentazione.

## Descrizione dei Componenti

(*Da fare dopo aver acquistato i componenti*)

## Flusso degli Eventi

(*Inserire anche un semplice diagramma di flusso*)

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

Dopo una prima, lunga, fase di impostazione dell'attività progettuale, legata principalmente al reperimento della componentistica e all'apprendimento dell'ambiente di sviluppo (essendo la prima esperienza di programmazione a un così basso livello), possiamo affermare che la soluzione proposta rappresenti un punto di partenza per future espansioni e adattamenti a vari contesti applicativi, che vanno dalla domotica ad applicazioni industriali, in cui il rilevamento dei valori di temperatura e di umidità in tempo reale possa essere un *game-changer*.

In questo senso, possibili espansioni riguardano l'inserimento di attuatori e sensori che possano permettere alla soluzione di interfacciarsi con altri dispositivi e di fungere da regolatore del comportamento di questi ultimi, senza, peraltro, dover modificare il codice sorgente fin dove scritto: nel caso domestico, per esempio, si potrebbe pensare di centralizzare il controllo della temperatura aggiungendo pulsanti, per la determinazione dei valori desiderati, e altra componentistica, per permettere la comunicazione con le unità di controllo del clima (es. climatizzatori) e l'imposizione di tali valori fino al soddisfacimento di condizioni sia temporali che ambientali.

Inoltre, riteniamo che l'approccio seguito in fase di programmazione permetta al codice di poter essere riutilizzato anche su altri dispositivi target, semplicemente variando alcuni parametri di configurazione opportunamenti astratti.
