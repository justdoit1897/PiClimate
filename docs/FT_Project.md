<link rel="stylesheet" type="text/css" href="stili.css">

# Introduzione

I software embedded rappresentano il cuore invisibile di molte delle tecnologie che utilizziamo quotidianamente. Sono software specializzati, incorporati in dispositivi elettronici e macchinari industriali, progettati per eseguire specifiche funzioni senza l'interfaccia di un utente. Questi sistemi sono onnipresenti, dall'elettronica domestica agli impianti industriali, e forniscono l'automazione e il controllo necessari per semplificare le nostre vite e migliorare l'efficienza in molti settori.

Immaginiamo una sala server, il cuore di un'organizzazione che ospita server e infrastrutture informatiche critiche. Valori come **temperatura** ed **umidità** devono essere attentamente monitorati e regolati per garantire il funzionamento ottimale dei dispositivi e prevenire danni dovuti al surriscaldamento o alla condensa.

In particolar modo, la **temperatura** ambientale dovrebbe essere mantenuta entro i **20-24 °C**, dato che un'elevata temperatura può causare surriscaldamento e danneggiare gli apparati, mentre una temperatura troppo bassa potrebbe causare condensa o problemi di umidità.

L'intervallo di **umidità** consigliato per una sala server è generalmente tra il **40%** e il **60%**. Un'umidità troppo elevata può causare corrosione e danneggiare i componenti elettronici, mentre un'umidità troppo bassa può causare scariche elettrostatiche.

Qui entra in gioco un progetto embedded dedicato alla gestione di questi parametri ambientali. Il nostro sistema embedded è progettato per:

1. **Monitoraggio Costante** : Utilizza sensori di temperatura e umidità per monitorare costantemente le condizioni all'interno della sala server.
2. **Controllo Automatico** : In base ai dati raccolti dai sensori, il sistema può attivare o disattivare sistemi di raffreddamento o umidificatori per mantenere le condizioni ottimali.
3. **Allarmi e Notifiche** : Se il sistema rileva condizioni fuori norma, può generare allarmi visivi per il personale responsabile, consentendo di reagire rapidamente a eventuali problemi.

Questo progetto embedded rappresenta un esempio concreto di come i sistemi embedded siano essenziali per garantire l'affidabilità delle infrastrutture tecnologiche moderne. La sua capacità di monitorare e gestire in modo autonomo le condizioni ambientali contribuisce in modo significativo alla continuità operativa delle aziende e alla protezione delle risorse informatiche critiche.

# Hardware

In questa sezione verranno elencati i componenti hardware necessari all'implementazione del progetto e verrà illustrato lo schema di collegamento degli stessi.

Successivamente, si andrà a descrivere nel dettaglio ciascun componente, in modo da offrire una guida a chiunque voglia intraprendere un progetto simile.

## Lista Componenti

|                 Nome                 | Quantità |
| :-----------------------------------: | :-------: |
|        Raspberry&trade;Pi 1 B        |     1     |
|        Cavo USB-A a Micro USB        |     1     |
|             MicroSD 32GB             |     1     |
|  FTDI FT232RL UART to USB interface  |     1     |
|              Breadboard              |     1     |
|             Sensore DHT22             |     1     |
|          Display I2C LCD2004          |     1     |
|           LED colore ROSSO           |     1     |
|           LED colore VERDE           |     1     |
|     Resistori da$\ 100 \Omega$     |     2     |
|      Ventola$\ 5 \mathrm V$ DC      |     1     |
|               Pulsanti               |     1     |
| Resistori da$\ 10 \mathrm k \Omega$ |     1     |
|         Cavo USB-A a Mini USB         |     1     |
|            Cavetti Jumper            |   Q. B.   |

## Breadboard Schematic

<img src='./images/schema_FT.png' >

## Descrizione Componenti

### Raspberry&trade;Pi 1 B [1]

È il **dispositivo target** del progetto. Esso monta il [SoC Broadcom 2835](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf) con processore ARM1176JZFS a $700 \mathrm{MHz}$ che, nonostante le caratteristiche non più all'avanguardia, si presta ancora bene nella gestione dei compiti richiesti.

<img src='./images/raspberry-pi-1-modello-b.jpg' alt='Raspberry Pi 1B' width="50%">

<img src='./images/Pi-GPIO-header-26-sm.png' alt='Raspberry Pi 1B GPIO Headers' width="320" style='float:right; margin-top:120px'>

Specifiche di sistema:

* SoC Broadcom BCM2835
* CPU ARM1176JZF-S core a $700 \mathrm{MHz}$
* GPU Broadcom VideoCore IV
* 512 MB
* 2 Porte USB 2.0
* Video Output Composito (PAL e NTSC), HDMI o LCD diretto (DSI)
* Audio Output tramite Jack $3.5 \mathrm{mm}$ o Audio over HDMI
* Archiviazione: SD/MMC/SDIO
* 10/100 Ethernet (RJ45)
* Periferiche di Basso Livello:
  * 8 x GPIO
  * UART
  * bus I2C
  * bus SPI con due chip selects
  * $+3.3 \mathrm V$
  * $+5 \mathrm V$
  * GND
* Requisiti di alimentazione: $5 \mathrm V$ @ $700 \mathrm{mA}$ tramite MicroUSB o Header GPIO

### Modulo FTDI FT232RL

<img src='https://ae01.alicdn.com/kf/Sf822fcc1fa73463884bf733913cd6d36M/FT232RL-FT232-FTDI-3-3V-5-5V-modulo-adattatore-convertitore-seriale-TYPE-C-Mini-porta-per.jpg' width="320" style='float:right; margin-top:50px; border: 1px solid; margin-left: 5px'>

L'FTDI FT232RL è un convertitore USB-to-Serial, un dispositivo che traduce i dati tra il protocollo USB (Universal Serial Bus) e il protocollo seriale RS-232. Questo chip è ampiamente utilizzato per collegare dispositivi seriali, come microcontrollori, a computer moderni dotati di porte USB.

È noto per la sua semplicità d'uso e la compatibilità con numerosi sistemi operativi.

Può essere alimentato direttamente dalla porta USB del computer, eliminando la necessità di un'alimentazione esterna.

Questo modulo è necessario per fornire una porta di comunicazione virtuale al dispositivo di sviluppo (il PC) e consentire di inviare dati al dispositivo target (Il Raspberry Pi).

Il modulo FTDI è connesso al computer tramite la porta USB e alla UART1 del Pi secondo la seguente configurazione:

| FTDI Pin | Raspberry Pi Pin |
| :------: | :---------------: |
|    RX    |   GPIO14 / TXD0   |
|    TX    |   GPIO15 / RXD0   |
|   GND   |        GND        |

### Modulo Display I2C LCD2004 [2]

<img src='https://m.media-amazon.com/images/I/61JbSbfWshL.jpg' width="320" style='float:right; margin-top:50px; border: 1px solid; margin-left: 5px'>

Il modulo Display I2C LCD2004 è un componente ampiamente utilizzato in progetti elettronici per visualizzare testo e informazioni su un display LCD (Liquid Crystal Display) alfanumerico con 20 caratteri per 4 righe.

Questo modulo è noto per la sua versatilità e facilità d'uso grazie all'**interfaccia I2C**, che semplifica notevolmente la connessione e il controllo da parte di microcontrollori e dispositivi embedded, oltre a ridurre notevolmente il numero di pin necessari per il collegamento.

Il sistema richiede l'uso di un display LCD 2004 per la presentazione delle informazioni all'utente finale ed è caratterizzato da una griglia 20 $\times$ 4 di **caratteri**, ciascuno dei quali costituito da un valore standard di 5 $\times$ 8 **dots**, codificati ASCII (la cui gestione da parte della ROM del modulo è visibile in figura).

<table style='border:none; text-align: center;'>
   <tr style='border:none'>
      <td rowspan="2" style='border:none'>
         <img src="images/lcd2004/ascii_lcd.png" alt="Codifica ASCII e Gestione ROM LCD 2004" style="display: inline; position: relative; left: 0%; margin-top:50px; border: 1px solid;" />
      </td>
      <td style='border:none'>
         <img src="images/lcd2004/parallel_int.png" alt="Interfaccia Parallela LCD 2004" style="display: inline; position: relative; margin-top:50px; border: 1px solid;" />
      </td>
   </tr>
   <tr style='border:none'>
      <td style='border:none'>
         <table style="border: 1px solid">
        <tr>
            <th>Pin</th>
            <th>Simbolo</th>
            <th>Funzione</th>
        </tr>
        <tr>
            <td>1</td>
            <td>VSS</td>
            <td>Power Ground</td>
        </tr>
        <tr>
            <td>2</td>
            <td>VDD</td>
            <td>Power supply for logic ciurcuit +5V</td>
        </tr>
        <tr>
            <td>3</td>
            <td>V0</td>
            <td>For LCD drive voltage (variable)</td>
        </tr>
        <tr>
            <td>4</td>
            <td>RS(C/D)</td>
            <td>H: Display Data <br> L: Display Instruction</td>
        </tr>
        <tr>
            <td>5</td>
            <td>R/W</td>
            <td>H: Data Read (LCM to MPU) <br> L: Data Write (MPU to LCM)</td>
        </tr>
        <tr>
            <td>6</td>
            <td>E</td>
            <td style="text-align: left;">Enable Signal. <br> Write mode (R/W = L) data of DB <0:7> <br> is latched at the falling edge of E. <br> Read mode (R/W = H) DB <0:7> appears <br> the reading data while E is at high level. </td>
        </tr>
        <tr>
            <td>7-14</td>
            <td>DB0-DB7</td>
            <td>Data bus. There state I/O common terminal.</td>
        </tr>
        <tr>
            <td>15</td>
            <td>A</td>
            <td>Power for LED Backlight (+5V)</td>
        </tr>
        <tr>
            <td>16</td>
            <td>K</td>
            <td>Power for LED Backlight (GND)</td>
        </tr>
    	</table>
      </td>
   </tr>
</table>

Il modulo LCD2004 è connesso al Pi secondo la seguente configurazione:

| LCD2004 Pin | Raspberry Pi Pin |
| :---------: | :---------------: |
|     GND     |        GND        |
|     VCC     |        5V        |
|     SDA     |   GPIO2 / SDA1   |
|     SCL     |   GPIO3 / SCL1   |

### Modulo per la Serializzazione - I2C Backpack [3]

<img src='https://m.media-amazon.com/images/I/61xWHXGsnsL.jpg' width="320" style='float:left; margin-top:50px; border: 1px solid; margin-right: 30px'>

Si tratta di un modulo usato tipicamente per serializzare la comunicazione tra un microcontrollore e un altro device. Nel caso specifico, il modulo si presenta nella forma di un backpack da saldare al display (nel nostro caso era già saldato) e caratterizzato da quattro pin per il collegamento con il MCU:

* due pin, rispettivamente **VCC** e **GND**, usati per l'alimentazione del modulo;
* un pin, chiamato **SDA**, per l'invio dei dati serializzati;
* un pin, chiamato **SCL**, per la sincronizzazione dei segnali di clock.

A questi, si aggiungono altri 9 pin, di cui 8 usati come bus di dati e uno usato (eventualmente) per la gestione degli interrupt inviati dal MCU.

Il modulo richiede una tensione di $5 \mathrm V$ ed è provvisto di un potenziometro per il **controllo del contrasto** dei caratteri. Il controllo della luminosità è possibile via hardware, tramite una circuiteria *ad hoc*, o via software, tramite opportune istruzioni.

### Sensore di temperatura e umidità DHT22 [4]

<img src='https://img.kwcdn.com/product/Fancyalgo/VirtualModelMatting/4e1160ec5dfb387ab03c938666ab9c5e.jpg?imageMogr2/auto-orient%7CimageView2/2/w/1300/q/80/format/webp' width="320" style='float:right; border: 1px solid; margin-left: 5px'>

Il sensore permette il monitoraggio della temperatura e dell'umidità nell'ambiente circostante, ed è caratterizzato da un sensore di base della famiglia AM2302, che si caratterizza per la capacità di gestione di segnali digitali con una precisione di 0.5 °C per la temperatura e di 2% RH per l'umidità, rilevando valori di temperatura tra i -40°C e i +80°C e di umidità tra lo 0% e il 100%.

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

### LEDs

<img src='https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/LEDs.jpg/1200px-LEDs.jpg' width="320" style='float:right; margin-top:50px; border: 1px solid; margin-left: 5px'>

Un LED, acronimo di Light Emitting Diode, è un dispositivo semiconduttore che emette luce quando una corrente elettrica passa attraverso di esso. Questi piccoli dispositivi sono diventati una parte fondamentale della tecnologia moderna, con applicazioni in una vasta gamma di settori.

Nel sistema in esame sono presenti due LED, uno rosso e uno verde, che hanno lo scopo di indicare la bontà dei parametri.

Il LED rosso lampeggiante indica che i valori sono fuori scala e bisogna fare qualcosa per riportarli alla normalità, mentre un LED verde acceso indica che i valori registrati sono buoni e l'ambiente è idoneo. Questa indicazione visiva ha lo scopo di trasmettere una informazione immediata agli utenti in quanto, essendo facilmente comprensibile, fornisce loro un feedback chiaro sullo stato ambientale.

I LED hanno due connessioni, l'**anodo** (+) e il **catodo** (-), che devono essere collegate correttamente per farli funzionare.

In un microcontrollore o in una scheda come il Raspberry Pi, i pin GPIO sono i nostri strumenti per controllare i componenti elettronici. Per connettere un LED, il suo anodo (+) viene collegato a uno dei pin GPIO, mentre il catodo (-) viene connesso a terra (GND).

Tuttavia, c'è un aspetto cruciale da tenere a mente: la necessità di una resistenza. Quando un LED è collegato direttamente a una sorgente di tensione senza una resistenza, la corrente può diventare troppo elevata e danneggiare il LED. Le resistenze svolgono il ruolo di "limitatori di corrente", regolando la quantità di corrente che fluisce attraverso il LED. La giusta resistenza assicura che il LED funzioni in modo sicuro e durevole.

Nella tabella sottostante sono riportati i pin GPIO attraverso i quali vengono pilotati i LED:

|  LED  | Raspberry Pi Pin |
| :---: | :---------------: |
|  RED  |      GPIO23      |
| GREEN |      GPIO24      |

### Pulsante

<img src='https://learningscratch519975251.files.wordpress.com/2021/04/button-fig-1.png?w=536' width="320" style='float:left; margin-right: 10px; border: 1px solid; margin-right: 15px'>

Il pulsante scelto è un pulsante a quattro pin, per uno switch a due poli.

Per il suo scopo nel sistema è necessario che il pulsante sia configurato in pull-up (il cui schema esemplificativo è presentato in figura), per cui, in fase di riposo (pulsante non premuto), la corrente può circolare, permettendo al sistema di funzionare, mentre, a seguito di una pressione, viene effettuata un'azione bloccante rispetto alla corrente, che impedisce al sistema di funzionare, mandandolo in reset.

<img src='https://global.discourse-cdn.com/nvidia/original/3X/b/8/b886440071a627ea9efbae5b2638a8625214d9ca.png' width="320" style='float:right; margin-right: 10px; border: 1px solid; margin-right: 15px'>

Nella tabella sottostante sono riportati i pin GPIO attraverso i quali viene pilotato il pulsante:

| Button Pin | Raspberry Pi Pin |
| :--------: | :---------------: |
| DATA WIRE |       GPIO8       |
|    VCC    | $+3.3\mathrm V$ |
|   GROUND   |        GND        |

### Ventola di Raffreddamento 5V-3 pin

<img src='https://thepihut.com/cdn/shop/products/software-controllable-5v-30mm-fan-for-raspberry-pi-the-pi-hut-105236-39805255418051_1500x.jpg?v=1667563351' width="320" style='float:left; margin-top:50px; border: 1px solid; margin-right: 30px'>

Si tratta di una ventola di dimensioni 60x60x10 mm, utilizzata per dissipare il calore e mantenere una temperatura ottimale all'interno di dispositivi elettronici. È composta da 3 pin:

1. **GND (Ground)** : Questo pin è collegato alla terra e serve come riferimento elettrico per il circuito della ventola.
2. **VCC (Voltage Common Collector)** : Questo pin fornisce l'alimentazione elettrica alla ventola e deve essere collegato a una sorgente di alimentazione a 5V per far funzionare correttamente la ventola.
3. **GPIO (General-Purpose Input/Output)** : Questo pin è utilizzato per controllare la ventola. Può essere collegato a una porta GPIO di un microcontrollore o di un computer, come il Raspberry Pi, per regolare la velocità della ventola o attivarla/disattivarla in base alle necessità di raffreddamento.

La ventola è connessa al Pi secondo la seguente configurazione:

| Fan Pin | Raspberry Pi Pin |
| :------: | :---------------: |
|   GND   |        GND        |
|   VCC   | $+5 \mathrm V$ |
|    EN    |      GPIO24      |

## GPIO assignment

Poiché questo progetto incorpora una serie di componenti esterni fondamentali per il suo funzionamento, è cruciale avere una panoramica chiara e ben organizzata dei pin GPIO coinvolti e delle rispettive funzioni a cui sono assegnati. Questa informazione è essenziale per garantire che il sistema funzioni in modo impeccabile e che i collegamenti tra i componenti siano stabiliti correttamente.

Nella tabella sottostante, vi è riassunta la panoramica dei pin GPIO utilizzati. Essa ha lo scopo di tenere traccia dei collegamenti e delle assegnazioni dei pin, semplificando la manutenzione futura e agevolando il lavoro di chiunque debba comprendere o estendere il progetto.

|   GPIO Pin   |  Function  |       Device       |
| :----------: | :---------: | :-----------------: |
| GPIO2 / SDA1 | ALT0 / SDA1 |       LCD2004       |
| GPIO3 / SCL1 | ALT0 / SCL1 |       LCD2004       |
|    GPIO8    |    INPUT    |       BUTTON       |
|    GPIO14    |     TX     |  UART Transmitter  |
|    GPIO15    |     RX     |    UART Receiver    |
|    GPIO18    |    INPUT    |    DHT22/AM2302    |
|    GPIO23    |   OUTPUT   |      LED Rosso      |
|    GPIO24    |   OUTPUT   | LED Verde / Ventola |

# Environment

Per la fase di sviluppo sono stati utilizzati:

* PC con distribuzione Linux (Ubuntu) con installato G-Forth, minicom e picocom
* Interprete FORTH per soluzioni bare-metal [pijFORTHos](https://github.com/organix/pijFORTHos).

## pijFORTHos

Gli interpreti FORTH possono essere facilmente implementati su macchine con risorse limitate senza la necessità di un sistema operativo, rendendoli particolarmente adatti per lo sviluppo interattivo "bare-metal".

L'ambiente **pijFORTHos** si basa su un interprete FORTH in assembly chiamato **JonesForth**, inizialmente sviluppato per l'architettura i686 da Richard WM Jones.

JonesForth è noto per la sua semplicità ed è stato adattato con successo a numerose architetture diverse. Uno di questi adattamenti, noto come Jonesforth-ARM, ha portato all'implementazione di un interprete FORTH "bare-metal" per il Raspberry Pi, noto come **pijFORTHos**.

Questo interprete non solo permette l'esecuzione di codice FORTH direttamente sulla piattaforma Raspberry Pi, ma consente anche la connessione con altre macchine attraverso la console seriale del Raspberry Pi.

Questa capacità di comunicazione seriale offre un'interessante opportunità per il controllo e la comunicazione remota con il Raspberry Pi, rendendo **pijFORTHos** un ambiente versatile per lo sviluppo e l'interazione con il sistema embedded.

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

### Automatizzazione della Connessione Seriale con Picocom: `avvio_picocom.sh`

Il seguente script Bash svolge un ruolo fondamentale nella gestione di una connessione seriale tramite il programma Picocom, uno strumento molto utile quando si lavora con dispositivi embedded o hardware, poiché consente di stabilire una comunicazione seriale tra un computer host e il dispositivo target.

In questo script, definiamo alcune variabili chiave che determinano i parametri della connessione seriale. Il dispositivo di destinazione è specificato come **/dev/ttyUSB0**, che è spesso utilizzato per rappresentare una porta seriale USB su sistemi Linux.

La **velocità di trasmissione** (BAUD) è impostata su **115200 bit al secondo**, un valore comune nelle comunicazioni seriali.

Il comando principale all'interno dello script è l'invocazione di Picocom con le opzioni appropriate per stabilire la connessione seriale. In particolare, notiamo l'uso del flag `-r`, che abilita la registrazione della sessione seriale in un file di log, e l'opzione `--imap delbs`, che specifica come gestire i caratteri di cancellazione "Backspace" nella comunicazione.

Inoltre, l'uso di `ascii-xfr` indica che verrà utilizzato un protocollo di trasferimento dati ASCII durante la comunicazione seriale, il che può essere particolarmente utile per il trasferimento di dati tra il computer host e il dispositivo target.

```
#!/bin/bash

DEVICE=/dev/ttyUSB0 
BAUD=115200  

sudo picocom -b $BAUD -r -l $DEVICE --imap delbs -s "ascii-xfr -sv -l100 -c10"
```

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

# Software

## Flusso di Lavoro

Prima di immergerci nel codice sorgente e nelle specifiche implementazioni tecniche, è essenziale stabilire una base solida di comprensione del **flusso di lavoro** del progetto.

Questa panoramica iniziale fornisce un quadro concettuale che aiuta a mettere in prospettiva le diverse parti del progetto e a chiarire l'ordine sequenziale in cui avvengono gli eventi.

1. **Inizializzazione** : All'avvio, il sistema esegue un'operazione di **inizializzazione**, configurando il sensore di temperatura e umidità, gli attuatori (ventola e LED), e imposta le soglie di temperatura e umidità desiderate (**20-24 °C** e **40-60%** di umidità). Il sistema entra quindi in uno stato di attesa.
2. **Monitoraggio Continuo** : Il sistema monitora costantemente i dati proveniente dal sensore di temperatura e umidità per rilevare eventuali variazioni. Questo monitoraggio avviene in un ciclo continuo.
3. **Controllo della Temperatura e dell'Umidità** : Quando il sistema rileva che la temperatura o l'umidità escono dai range desiderati, mostra nel display LCD un messaggio per indicare il problema e, successivamente, attiva un LED rosso lampeggiante un numero $n$ di volte. In base al valore di $n$ si può riconoscere visivamente il tipo di problema, nel caso in cui il display LCD dovesse essere malfunzionante.
4. **Raffreddamento** : Nel caso la temperatura sia troppo alta, il sistema attiva, in concomitanza ad un LED verde, una ventola di raffreddamento per abbassare la temperatura all'interno della sala server. La ventola e il LED rimangono accesi fino a quando la temperatura non rientra nei limiti accettabili.
5. **Controllo della Temperatura e dell'Umidità Ridotto** : Una volta che la temperatura e l'umidità rientrano nei range desiderati, il sistema spegne la ventola di raffreddamento e disattiva il LED verde.
6. **Indicazione di Normale Funzionamento** : Quando la temperatura e l'umidità sono nuovamente sotto controllo, il sistema attiva spegne tutti i LED e mostra sul display LCD i valori di temperatura ed umidità rilevati dal sensore DHT22.
7. **Controllo del Pulsante di Reset** : Il sistema monitora costantemente il pulsante di reset. Se il pulsante viene premuto, il sistema esce dal ciclo di monitoraggio e rientra in uno stato di attesa, pensato per gestire un eventuale servizio di manutenzione.
8. **Monitoraggio Continuo (Ripetizione)** : Il sistema embedded continua a monitorare costantemente i dati dai sensori e ripete il processo di controllo della temperatura e dell'umidità, verificando anche lo stato del pulsante di reset.

Ecco una tabella riassuntiva dei tipi di malfunzionamento in funzione di quante volte lampeggia il LED rosso:

| n |    Tipo malfunzionamento    |
| :-: | :-------------------------: |
| 3 | Temperatura sotto la soglia |
| 5 |     Temperatura elevata     |
| 4 |  Umidità sotto la soglia  |
| 6 |      Umidità elevata      |

## Codice

L'approccio seguito in fase di scrittura del software prevede la produzione di moduli a sé stanti, con la condizione di essere caricati solo successivamente ad alcuni file essenziali per la definizione di funzioni di utilità e costanti di interfacciamento con il microcontrollore.

### Makefile

Per il deployment del sistema completo è stato realizzato un semplice makefile che concatena tutti i singoli file nell'ordine corretto e, per non appesantire il trasferimento all'interno del MCU, elimina tutti i commenti all'interno del sorgente completo, come si evince dal seguente listato

```
all: code.f

clean:
	rm -f code.f
	rm -f final.f

code.f:
	cat ./src/useful_jf.f >> code.f
	cat ./src/utils.f >> code.f
	cat ./src/gpio_FT.f >> code.f
	cat ./src/timer.f >> code.f
	cat ./src/dht_sensor.f >> code.f
	grep -v '^ *\\' code.f > final.f
```

**DEFINIRE LISTA E NOMI FILE IN SEGUITO**

### jonesforth.f

Il file è necessario in quanto contiene parole normalmente definite in FORTH ma che l'implementazione basilare di pijFORTHos non comprende di default. In ogni caso, il file è disponibile nel `<a href='https://github.com/organix/pijFORTHos'>`repository `</a>` su github.com.

```
: '\n' 10 ;
: BL 32 ;
: ':' [ CHAR : ] LITERAL ;
: ';' [ CHAR ; ] LITERAL ;
: '(' [ CHAR ( ] LITERAL ;
: ')' [ CHAR ) ] LITERAL ;
: '"' [ CHAR " ] LITERAL ;
: 'A' [ CHAR A ] LITERAL ;
: '0' [ CHAR 0 ] LITERAL ;
: '-' [ CHAR - ] LITERAL ;
: '.' [ CHAR . ] LITERAL ;
: ( IMMEDIATE 1 BEGIN KEY DUP '(' = IF DROP 1+ ELSE ')' = IF 1- THEN THEN DUP 0= UNTIL DROP ;
: SPACES ( n -- ) BEGIN DUP 0> WHILE SPACE 1- REPEAT DROP ;
: WITHIN -ROT OVER <= IF > IF TRUE ELSE FALSE THEN ELSE 2DROP FALSE THEN ;
: ALIGNED ( c-addr -- a-addr ) 3 + 3 INVERT AND ;
: ALIGN HERE @ ALIGNED HERE ! ;
: C, HERE @ C! 1 HERE +! ;
: S" IMMEDIATE ( -- addr len )
	STATE @ IF
		' LITS , HERE @ 0 ,
		BEGIN KEY DUP '"'
                <> WHILE C, REPEAT
		DROP DUP HERE @ SWAP - 4- SWAP ! ALIGN
	ELSE
		HERE @
		BEGIN KEY DUP '"'
                <> WHILE OVER C! 1+ REPEAT
		DROP HERE @ - HERE @ SWAP
	THEN
;
: ." IMMEDIATE ( -- )
	STATE @ IF
		[COMPILE] S" ' TELL ,
	ELSE
		BEGIN KEY DUP '"' = IF DROP EXIT THEN EMIT AGAIN
	THEN
;
: DICT WORD FIND ;
: VALUE ( n -- ) WORD CREATE DOCOL , ' LIT , , ' EXIT , ;
: TO IMMEDIATE ( n -- )
        DICT >DFA 4+
	STATE @ IF ' LIT , , ' ! , ELSE ! THEN
;
: +TO IMMEDIATE
        DICT >DFA 4+
	STATE @ IF ' LIT , , ' +! , ELSE +! THEN
;
: ID. 4+ COUNT F_LENMASK AND BEGIN DUP 0> WHILE SWAP COUNT EMIT SWAP 1- REPEAT 2DROP ;
: ?HIDDEN 4+ C@ F_HIDDEN AND ;
: ?IMMEDIATE 4+ C@ F_IMMED AND ;
: WORDS LATEST @ BEGIN ?DUP WHILE DUP ?HIDDEN NOT IF DUP ID. SPACE THEN @ REPEAT CR ;
: FORGET DICT DUP @ LATEST ! HERE ! ;
: CFA> LATEST @ BEGIN ?DUP WHILE 2DUP SWAP < IF NIP EXIT THEN @ REPEAT DROP 0 ;
: SEE
	DICT HERE @ LATEST @
	BEGIN 2 PICK OVER <> WHILE NIP DUP @ REPEAT
	DROP SWAP ':' EMIT SPACE DUP ID. SPACE
	DUP ?IMMEDIATE IF ." IMMEDIATE " THEN
	>DFA BEGIN 2DUP
        > WHILE DUP @ CASE
		' LIT OF 4 + DUP @ . ENDOF
		' LITS OF [ CHAR S ] LITERAL EMIT '"' EMIT SPACE
			4 + DUP @ SWAP 4 + SWAP 2DUP TELL '"' EMIT SPACE + ALIGNED 4 -
		ENDOF
		' 0BRANCH OF ." 0BRANCH ( " 4 + DUP @ . ." ) " ENDOF
		' BRANCH OF ." BRANCH ( " 4 + DUP @ . ." ) " ENDOF
		' ' OF [ CHAR ' ] LITERAL EMIT SPACE 4 + DUP @ CFA> ID. SPACE ENDOF
		' EXIT OF 2DUP 4 + <> IF ." EXIT " THEN ENDOF
		DUP CFA> ID. SPACE
	ENDCASE 4 + REPEAT
	';' EMIT CR 2DROP
;
: :NONAME 0 0 CREATE HERE @ DOCOL , ] ;
: ['] IMMEDIATE ' LIT , ;
: EXCEPTION-MARKER RDROP 0 ;
: CATCH ( xt -- exn? ) DSP@ 4+ >R ' EXCEPTION-MARKER 4+ >R EXECUTE ;
: THROW ( n -- ) ?DUP IF
	RSP@ BEGIN DUP R0 4-
        < WHILE DUP @ ' EXCEPTION-MARKER 4+
		= IF 4+ RSP! DUP DUP DUP R> 4- SWAP OVER ! DSP! EXIT THEN
	4+ REPEAT DROP
	CASE
		0 1- OF ." ABORTED" CR ENDOF
		." UNCAUGHT THROW " DUP . CR
	ENDCASE QUIT THEN
;
: ABORT ( -- ) 0 1- THROW ;
: PRINT-STACK-TRACE
	RSP@ BEGIN DUP R0 4-
        < WHILE DUP @ CASE
		' EXCEPTION-MARKER 4+ OF ." CATCH ( DSP=" 4+ DUP @ U. ." ) " ENDOF
		DUP CFA> ?DUP IF 2DUP ID. [ CHAR + ] LITERAL EMIT SWAP >DFA 4+ - . THEN
	ENDCASE 4+ REPEAT DROP CR
;
: BINARY ( -- ) 2 BASE ! ;
: OCTAL ( -- ) 8 BASE ! ;
: 2# BASE @ 2 BASE ! WORD NUMBER DROP SWAP BASE ! ;
: 8# BASE @ 8 BASE ! WORD NUMBER DROP SWAP BASE ! ;
: # ( b -- n ) BASE @ SWAP BASE ! WORD NUMBER DROP SWAP BASE ! ;
: UNUSED ( -- n ) PAD HERE @ - 4/ ;
: WELCOME
	S" TEST-MODE" FIND NOT IF
		." JONESFORTH VERSION " VERSION . CR
		UNUSED . ." CELLS REMAINING" CR
		." OK "
	THEN
;
WELCOME
HIDE WELCOME
```

### utils.f

Il file è necessario in quanto contiene alcune funzioni utilizzate in tutto il resto dell'applicazione, evitando di scrivere codice superfluo.

```
 
\ ABS ( n -- |n| )
\ Parola usata per sostituire un numero passato in input con il suo valore assoluto

: ABS DUP 0< IF -1 * THEN ;
 
\ BILS ( disp -- 1<<disp )
\ Parola usata per generare un bit shiftato di un numero di posizioni passato in input
 
: BILS 1 SWAP LSHIFT ;
 
\ BIC ( a1 a2 -- a1&!a2 )
\ Parola usata per eseguire un'operazione di bit-clear. Dati due valori in input, viene
\ restituito il primo valore, in cui sono stati azzerati i bit posti a 1 del secondo valore.
 
: BIC INVERT AND ;
 
```

### gpio.f

Il file è necessario in quanto contiene tutte le definizioni di parole e costanti necessarie ad operare con i pin GPIO del Raspberry&trade; Pi. In esso sono state definite le costanti utili a identificare gli **indirizzi** dei principali registri su cui abbiamo operato (es. `GPFSEL0`, `GPSEL1`), oltre che gli indirizzi base per particolari set di registri, utilizzati all'interno di alcune parole per ricavare gli indirizzi esatti degli altri registri dello stesso set (es. la costante `GPLEV0` che, usata insieme alla parola `GPLEV` permette di ricavare anche l'indirizzo del registro `GPLEV1`).
All'interno del file sono definite anche le costanti associate ai **pin GPIO**, nello specifico identificati da un bit posto a 1 shiftato del loro valore numerico (es. `GPIO18` identifica il pin GPIO 18, ed è definito da un 1 shiftato a sinistra di 18 bit), utilizzando una notazione molto comune all'interno dei registri GPIO che permette di ridurre il numero di calcoli effettuati *on-the-fly* (es. attivare un pin GPIO posto in output può essere espresso banalmente come `GPIO7 GPSET0 !`).
Le ultime costanti che sono definite riguardano i possibili valori della FSEL per una specifica tripletta di bit, ricordando che nei registri `GPFSEL` la FSEL di ogni pin è gestita da una tripletta di bit opportunamente codificata (es. `INPUT` è associato alla tripletta `0b000`, dunque equivale al valore `0`).

Successivamente, possiamo trovare le definizioni di parole utilizzate per la **manipolazione dei pin GPIO** al fine di ricavare informazioni extra, come `N_GPIO` per ottenere il numero del pin associato ad una costante `GPIOx` o `GPSET` per ricavare l'indirizzo del registro `GPSET0/1` cui fa riferimento una costante `GPIOx`, più altre propriamente utilizzate per calcolare i valori da usare come parametri per altre parole, come `GPIO_LSB` e `FSEL_MASK` usate, rispettivamente, per calcolare la posizione del bit meno significativo nella tripletta usata nella gestione della FSEL e la maschera da utilizzare nella scrittura di una FSEL all'interno di un registro `GPFSEL`.
Interessanti sono, infine, le parole `ACTIVATE` e la sua controparte `DEACTIVATE`. Per quanto riguarda la prima, si tratta di una parola che opera a triplette di parametri, come evidenziato dalla sua definizione in stack notation `( fsel_n mode_n gpfsel_n ... fsel_0 mode_0 gpfsel_0 -- )`, che permette di rendere effettive le modifiche desiderate nei registri GPFSEL per un blocco di pin passato in input. Al contrario, `DEACTIVATE` permette di effettuare una *clear function* per una serie di pin passati in input, rendendoli disponibili a successive modifiche.

```
: ACTIVATE 
    DEPTH 3 /
    TIMES !
    BEGIN
        ENABLE_PIN
        TIMES @ 1 - TIMES !                 \ DECREMENTO TIMES AD OGNI ITERAZIONE
        TIMES @ 0=                          \ CONDIZIONE DI USCITA
    UNTIL ;

: DEACTIVATE
    DEPTH 3 /
    TIMES !
    BEGIN
        DISABLE_PIN
        TIMES @ 1 - TIMES !                 \ DECREMENTO TIMES AD OGNI ITERAZIONE
        TIMES @ 0=                          \ CONDIZIONE DI USCITA
    UNTIL ;
```

Le due parole fanno uso massiccio di altre due parole definite in questo file, ossia `ENABLE_PIN` e `DISABLE_PIN`, che effettuano rispettivamente un'operazione di **set function** e di **clear function** per apportare le modifiche relative ad un pin GPIO nel rispettivo registro `GPFSEL`.

```
: ENABLE_PIN
    DUP                 ( GPIOn_FSEL GPIOn_XMODE GPFSEL2 GPFSEL2 )
    >R @                ( GPIOn_FSEL GPIOn_XMODE GPFSEL2 @ )
    -ROT                ( GPFSEL2 @ GPIOn_FSEL GPIOn_XMODE )
    >R                  ( GPFSEL2 @ GPIOn_FSEL )
    BIC                 
    R>                  ( [ GPFSEL2 @ GPIOn_FSEL BIC ] GPIOn_XMODE )
    OR 
    R> ! ;

: DISABLE_PIN
    NIP
    DUP >R
    @ SWAP BIC
    R> ! ;
```

### time.f

Il file è necessario in quanto abbiamo deciso che la gestione dei tempi meritasse un modulo a sé stante. In esso sono contenute parole e costanti necessarie alla temporarizzazione degli eventi nel sistema.
All'interno del file sono presenti due modi distinti per la gestione dei tempi e, nello specifico, per la generazione di ritardi. Con la parola `DELAY` si è scelto un approccio più semplice, tra l'altro visto a lezione, secondo cui il sistema viene messo in uno stato di **busy-wait**, nel quale viene eseguito un numero di operazioni semplici (tipicamente una sottrazione) pari al valore passato in input.

Per alcuni dispositivi, però, questo approccio non ha sortito gli effetti desiderati, dunque si è reso necessario un approccio più preciso e che rendesse la temporizzazione degli eventi quanto più vincolato all'hardware del Raspberry&trade; Pi; dunque, abbiamo optato per usare il set di registri del **System Timer**. 
Questa periferica interna è dotata di quattro registri a 32 bit, detti **canali**, e due registri, `CLO` e `CHI`, che fungono da contatori del tempo che scorre dall'accensione del sistema. Nello specifico, questi due registri permettono di definire una variante del fattore di ritardo, in cui si utilizza come fonte dei dati proprio uno di questi registri, ossia `CLO`, e che segue un approccio molto semplice: si avvia il timer a partire dal valore corrente del registro e, all'interno di ogni iterazione di un ciclo, si valuta che il valore attuale differisca da quello di partenza per un numero di microsecondi passato in input. Questo secondo approccio è riscontrabile nella parola `CLK_DELAY`, in cui si è scelto di semplificare la lettura del codice attraverso la definizione di un'altra parola, `CURRENT_TIME`.

All'interno del file sono presenti anche funzioni basilari di utilità che permettono, per esempio, la conversione di un certo numero di secondi/millisecondi nello specifico numero di microsecondi da utilizzare in fase di timing (`MILLISECONDS` e `SECONDS`).

```
HEX
 
\ Per avere una gestione dei tempi quanto più real-time, usiamo anche il System Timer del RPi.
\ Definizione costanti System Timer
RPI1_BASE 3000 +    CONSTANT TIMER_BASE
TIMER_BASE 4 +      CONSTANT TIMER_COUNT
 
DECIMAL
 
\ MILLISECONDS ( ms -- us )
\ Permette di convertire in microsecondi un numero di millisecondi passato in input
 
: MILLISECONDS 1000 * ;
 
\ SECONDS ( s -- us )
\ Permette di convertire in microsecondi un numero di secondi passato in input
 
: SECONDS 1000 * MILLISECONDS ;
 
\ DELAY ( nops -- )
\ Manda il sistema in uno stato di busy-wait per un numero di operazioni passato in input
\ simulando un cronometro
 
: DELAY 
    BEGIN 
        1 - DUP
        0 =   
    UNTIL 
    DROP ;

\ CURRENT_TIME ( -- time )
\ Permette di prelevare il valore di clock attuale del CLO_REGISTER 
 
: CURRENT_TIME ( -- time ) TIMER_COUNT @ ;
 
\ CLK_DELAY ( us -- )
\ Pone il sistema in busy-wait per un certo numero di microsecondi passato in input
 
: CLK_DELAY CURRENT_TIME BEGIN 2DUP CURRENT_TIME - ABS SWAP > UNTIL 2DROP ;
 
```

### led.f

Il file permette la gestione della coppia di LED usati nel sistema proposto, comprendendo parole e costanti per l'accensione o per il lampeggiamento dei LED.

I LED rappresentano uno dei dispositivi di output più semplici e costituiscono una base fondamentale per implementare la selezione delle funzioni di un GPIO (General Purpose Input/Output). 


Nel contesto dell'attivazione di un GPIO in modalità di output, due registri cruciali sono coinvolti: **GPSETn** e **GPCLRn**.


```

```

### i2c.f

Il file permette di utilizzare il protocollo I2C in combinata con un display LCD grazie al backpack. Contiene parole e costanti utilizzate per implementare il suddetto protocollo, comprese quelle per impostare i registri del controller BSC su valori opportuni per abilitare il trasferimento di dati dal MCU al display in uno schema master-slave.

```

```

### lcd.f

Il file permette la gestione del modulo display utilizzato nel sistema proposto, successivamente all'impostazione del controller BSC del Raspberry&trade; Pi. Nel file sono incluse parole per la stampa di parole sul display e per la discriminazione tra l'invio di caratteri e quello di comandi, sfruttando la modalità di invio a 4 bit offerta dal display LCD2004.

```

```

### dht.f

Il file permette la gestione di un sensore DHT22/AM2302 secondo le modalità descritte precedentemente. Contiene la definizione di parole e costanti atte ad impostare le condizioni operative del sensore e a presentare i risultati del rilevamento in formato *human-readable*.

Innanzitutto, possiamo trovare le definizioni di alcune costanti strettamente legate al sensore DHT22/AM2302 in uso, come le temperature massima e minima registrabili, più le dichiarazioni di alcune variabili usate per la raccolta e il processing dei dati (es. `DATA` e `TEMPERATURE_IP`).
Sono, quindi, specificate le costanti di interfaccia tra il sensore e il Raspberry&trade; Pi, come il pin GPIO cui è connesso il DHT22/AM2302 (`GPIO18`) e le maschere usate per le operazioni sui registri (quest'ultima scelta resasi necessaria per non sovraccaricare il sistema di operazioni che sono molto frequenti).

Successivamente, troviamo le definizioni di alcune parole utili ai fini del rilevamento e del processing dei dati (`WAIT_PULLDOWN` e `WAIT_PULLUP`), oltre che di parole necessarie a far riferimento al sensore DHT in formato *human-readable* e utili a semplificare certe operazioni (`DHT_PIN_OUT` e `DHT_OUT`). Nello specifico, troviamo le parole:

* `DHT_PIN_OUT`, che permette di caricare sullo stack i valori necessari a impostare il pin GPIO cui è collegato il sensore in modalità output
* `DHT_OUT`, che rende effettiva l'impostazione del pin collegato al sensore in output
* `DHT_PIN_INP`, che permette di caricare sullo stack i valori necessari a impostare il pin GPIO cui è collegato il sensore in modalità input
* `DHT_INPUT`, che rende effettiva l'impostazione del pin collegato al sensore in input

Dopo di ché, sono presenti le parole necessarie al funzionamento vero e proprio del sensore:

* `SETUP_SENSOR`, che permette al Raspberry&trade; Pi di inviare la **start condition** al sensore, per cui bisogna impostare il pin in modalità **output** (scrivendo `0b001` nella tripletta del registro `GPFSEL` associata al pin), **spegnere** il pin (andando a impostare nel registro `GPCLR` il bit associato al pin GPIO), attendere 1 ms, **attivare** il pin (andando a impostare il bit associato al pin GPIO nel registro `GPSET`), per poi impostare il pin in modalità **input** (in modo analogo all'impostazione della modalità di output) e cedere, quindi, il controllo al sensore.
* `READ_DATA`, che permette al Raspberry&trade; Pi di **campionare** 40 valori inviati dal sensore DHT22/AM2302 e di salvarli nelle variabili `DATA` (primi 32 bit) e `CHECKSUM` (ultimi 8 bit), facendo uso della parola ausiliaria `READ_BIT`, con cui si effettua il campionamento di un bit **sulla base del tempo** in cui il sensore mantiene alta la data line: se ciò avviene per più di 50 µs, il sensore avrà trasmesso un bit pari a 1, altrimenti sarà un bit pari a 0.

Abbiamo, quindi, le parole usate per estrarre dai dati i valori reali della temperatura e dell'umidità (`GET_TEMPERATURE` e `GET_HUMIDITY`), sfruttando semplici correlazioni tra la posizione dei bit e il loro significato (spiegati in precedenza) e il fatto che il valore dell'una o dell'altra grandezza sono ottenuti dividendo per 10 il valore complessivo.

Infine, sono state definite semplici parole per la presentazione dei dati in formato *human-readable*, che permettono di stampare le misurazioni sia su riga di comando (`DHT>CMD`) che sul display LCD di cui è provvisto il sistema (`TEMPERATURE>LCD` e `HUMIDITY>LCD`).

Segue il codice sorgente.
 
```
DECIMAL
\\ 
\\ Definizione di costanti legate al sensore in uso, tra cui umidità minima, umidità massima,
\\ temperatura minima e temperatura massima registrabili
\\ 
-40                 CONSTANT MIN_TEMP
80                  CONSTANT MAX_TEMP
0                   CONSTANT MIN_HUM
100                 CONSTANT MAX_HUM
\\ 
\\ Definizione di variabili usate per contenere i dati raccolti
\\ 
\\ Dati e checksum
VARIABLE DATA
VARIABLE CHECKSUM
\\ 
\\ Parti intere e parti decimali di umidità e temperatura
\\ 
VARIABLE HUMIDITY_IP
VARIABLE HUMIDITY_DP
VARIABLE TEMPERATURE_IP
VARIABLE TEMPERATURE_DP
\\ 
\\ Definizione di costanti legate alla connessione sensore-microcontrollore, nello specifico
\\ maschera di FSEL per il pin in uso, valore da scrivere in GPFSEL per il pin in uso e per le 
\\ modalità input e output e registro GPFSEL associato al pin in uso.
\\ 
GPIO18 FSEL          CONSTANT GPIO18_FSEL
GPIO18 OUT MODE      CONSTANT GPIO18_OUT
GPIO18 INP MODE      CONSTANT GPIO18_INP
GPIO18 GPFSEL        CONSTANT GPIO18_GPFSEL
\\ 
\\ INT_MSG ( r q x -- )
\\ Parola usata per stampare su schermo la parte intera di un valore (temperatura/umidità)
\\ 
: INT_MSG 13 SET_CURSOR NUMBER >LCD NUMBER >LCD ;
\\
\\ DEC_MSG ( n x -- )
\\ Parola usata per stampare su schermo la parte decimale di un valore (temperatura/umidità)
\\ 
: DEC_MSG 16 SET_CURSOR NUMBER >LCD ;
\\ 
\\ WAIT_PULLDOWN ( n_gpio --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 1 a 0 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
\\ 
: WAIT_PULLDOWN 
    BEGIN 
        DUP PIN_LEVEL 
        0 = WHILE 
    REPEAT 
    DROP ;
\\
\\ WAIT_PULLUP ( n_gpio --  )
\\ Mantiene il sistema in busy-wait finché non viene rilevata una transizione da 0 a 1 nel
\\ registro GPLEV e sul bit associati al pin cui è collegato il sensore
\\ 
: WAIT_PULLUP 
    BEGIN 
        DUP PIN_LEVEL 
        1 = WHILE 
    REPEAT 
    DROP ;
\\  
\\ DHT_PIN_OUT ( -- )
\\ Scorciatoia per settare i parametri utili ad impostare la FSEL per il pin utilizzato in modalità output
\\ 
: DHT_PIN_OUT GPIO18_FSEL GPIO18_OUT GPIO18_GPFSEL ;
\\ 
\\ DHT_OUT ( -- )
\\ Imposta il pin in modalità output
\\ 
: DHT_OUT DHT_PIN_OUT ENABLE_PIN ;
\\  
\\ DHT_PIN_INP ( -- )
\\ Scorciatoia per settare i parametri utili ad impostare la FSEL per il pin utilizzato in modalità input
\\ 
: DHT_PIN_INP GPIO18_FSEL GPIO18_INP GPIO18_GPFSEL ;
\\ 
\\ DHT_INPUT ( -- )
\\ Imposta il pin in modalità input
\\ 
: DHT_INPUT DHT_PIN_INP ENABLE_PIN ;
\\ SETUP_SENSOR (  --  )
\\ Esegue le istruzioni necessarie a mandare lo start signal al sensore, necessario al rilevamento da parte di
\\ quest'ultimo. Nello specifico:
\\ - imposta il pin in output mode
\\ - attiva il bit associato al pin nel GPCLR opportuno e attende 1 ms
\\ - attiva il bit associato al pin nel GPSET opportuno
\\ - imposta il pin in input mode
\\ 
: SETUP_SENSOR 
    DHT_OUT
    GPIO18 DUP GPCLR !
    1 MILLISECONDS CLK_DELAY
    GPIO18 DUP GPSET !
    DHT_INPUT ;
\\ 
\\ READ_BIT ( -- )
\\ Viene usata per determinare se il sensore ha inviato al MCU uno 0 o un 1.
\\ Calcoliamo la differenza tra il momento in cui avviene un pullup (fine dell'inizio trasmissione)
\\ e quello, precedente, in cui è avvenuto un pulldown, che dev'essere almeno di 50 us, 
\\ la soglia che permette di affermare se è stato trasmesso uno 0 o un 1.
\\ 
: READ_BIT DUP WAIT_PULLDOWN TIMER_COUNT @ SWAP WAIT_PULLUP TIMER_COUNT @ SWAP - 50 > IF 1 ELSE 0 THEN ;
\\
\\ READ_DATA ( -- )
\\ Viene usata per effettuare la lettura di 40 bit per volta, conservando i primi 32 come dati effettivi nella
\\ variabile DATA, mentre gli altri 8 saranno usati come checksum nella variabile omonima.
\\ 
: READ_DATA 
    GPIO18 N_GPIO DUP DUP DUP WAIT_PULLDOWN WAIT_PULLUP
    39 BEGIN
        DUP 7 > IF
            DATA DUP @ 1 LSHIFT
        ELSE 
            CHECKSUM DUP @ 1 LSHIFT
        THEN
        3 PICK READ_BIT
        OR SWAP !
        1 - DUP 0 >
    WHILE REPEAT 2DROP ;
\\ 
\\ GET_HUMIDITY ( -- )
\\ Viene usata per ricavare la parte intera e la parte frazionaria dell'umidità dalla variabile DATA
\\ 
: GET_HUMIDITY 
    DATA @ 16 RSHIFT 10 /MOD DUP DUP MIN_HUM >= SWAP MAX_HUM <= AND
    IF
        HUMIDITY_IP ! 
        HUMIDITY_DP ! 
    ELSE
        2DROP
    THEN ;
\\ 
\\ GET_TEMPERATURE ( -- )
\\ Viene usata per ricavare la parte intera e la parte frazionaria della temperatura dalla variabile DATA
\\ 
: GET_TEMPERATURE 
    DATA @ 65535 AND 10 /MOD DUP DUP MIN_TEMP >= SWAP MAX_TEMP <= AND
    IF
        TEMPERATURE_IP !
        TEMPERATURE_DP !
    ELSE
        2DROP
    THEN ;
\\ 
\\ GET_READING ( -- )
\\ Parola comprensiva per ricavare i valori interi e decimali di temperatura e umidità
\\ 
: GET_READING GET_HUMIDITY GET_TEMPERATURE ;
\\ 
\\ HUMIDITY>CMD ( -- )
\\ Parola usata per stampare su riga di comando il valore di umidità ricavato
\\ 
: HUMIDITY>CMD ." Humidity: " HUMIDITY_IP ? ." . " HUMIDITY_DP ? ." %" ;
\\
\\ HUMIDITY>LCD ( -- )
\\ Parola usata per stampare su display LCD il valore di umidità ricavato
\\ 
: HUMIDITY>LCD 
    HUMIDITY_IP 10 /MOD ROW3 INT_MSG
    HUMIDITY_DP ROW3 DEC_MSG ;
\\  
\\ TEMPERATURE>CMD ( -- )
\\ Parola usata per stampare su riga di comando il valore di temperatura ricavato
\\ 
: TEMPERATURE>CMD ." Temperature: " TEMPERATURE_IP ? ." . " TEMPERATURE_DP ? ." *C" ;
\\ 
\\ TEMPERATURE>LCD ( -- )
\\ Parola usata per stampare su display LCD il valore di temperatura ricavato
\\ 
: TEMPERATURE>LCD 
    TEMPERATURE_IP 10 /MOD ROW2 INT_MSG
    TEMPERATURE_DP ROW2 DEC_MSG ;
\\ 
\\ DHT>CMD ( -- )
\\ Parola comprensiva per stampare su riga di comando i valori di temperatura e di umidità ricavati
\\ 
: DHT>CMD TEMPERATURE>CMD ."  - " HUMIDITY>CMD CR ;
\\ 
\\ MEASURE ( -- )
\\ Parola comprensiva per l'esecuzione dell'intero processo per una singola misurazione del sensore
\\ 
: MEASURE 0 DATA ! 0 CHECKSUM ! SETUP_SENSOR READ_DATA GET_READING DHT>CMD DROP ;

: DHT_OK 
    S" TEST-MODE" FIND NOT IF 
        CR ."           **********" CR
        ." dht.f CARICATO CORRETTAMENTE" CR 
        ." SUCCESSIVAMENTE CARICARE button.f" CR 
        ." OK " CR
        ."           **********" CR
    THEN ;

DHT_OK
 
```

### button.f

Il file permette di utilizzare il pulsante di reset previsto dal sistema. Contiene la definizione di parole e costanti utilizzate per impostare opportunamente i registri necessari e per determinare se il pulsante è stato premuto.

Segue il codice sorgente, in cui sono chiariti passi operativi e le ratio dietro le scelte implementative.

```
HEX
 
\ Definizione di costanti per il setting del registro GPPUD
 
1                   CONSTANT DOWN
2                   CONSTANT UP
 
\ Definizione di costanti per la gestione del GPIO associato al bottone di reset
 
GPIO8               CONSTANT RESET_BTN
GPIO8 FSEL          CONSTANT GPIO8_FSEL
GPIO8 INP MODE      CONSTANT GPIO8_INPUT
GPIO8 GPFSEL        CONSTANT GPIO8_GPFSEL
 
\ RESET_PIN ( -- fsel input_mode gpfsel )
\ Permette di caricare sullo stack le informazioni per impostare il pin associato
\ al bottone di reset in modalità input
 
: RESET_PIN GPIO8_FSEL GPIO8_INPUT GPIO8_GPFSEL ;
 
\ SET_PULL ( gpio pud --  )
\ Permette di eseguire le operazioni necessarie all'impostazione di un pin passato in input
\ in pull-up/pull-down (modalità passata in input). Avendo utilizzato un modello precedente al 4
\ bisogna seguire un protocollo più articolato, che prevede di:
\ 1. scrivere nel registro GPPUD il valore di pud per abilitare il controllo pull-up/pull-down
\ 2. attendere 150 cicli di clock
\ 3. impostare a 1 il bit nel registro GPPUDCLK0/1 corrispondente al numero del pin di cui abilitare
\  il controllo, per abilitare il segnale di clock ad esso associato
\ 4. attendere ulteriori 150 cicli di clock
\ Dal momento che il pulsante dev'essere in pullup perpetuo, vengono omesse le ultime due fasi:
\ 5. scrivere nel registro GPPUD per rimuovere il segnale di controllo
\ 6. scrivere nel registro GPPUDCLK0/1 per rimuovere il clock
 
: SET_PULL
    GPPUD !
    150 MILLISECONDS DELAY
    GPPUDCLK0 DUP @
    ROT 2DUP
    BIC >R
    OR OVER !
    150 MILLISECONDS DELAY
    R> SWAP ! ;
 
\ INIT_BTN ( -- )
\ Permette di inizializzare il pulsante di reset, abilitando la modalità di input sul pin associato,
\ impostando per esso la modalità pull-up e attivando due registri per l'individuazione di eventi:
\ GPREN0 (per il rilevamento di innalzamenti di tensione, ossia transizioni del tipo '011') e GPFEN0
\ (per il rilevamento di abbassamenti di tensione, ossia transizioni del tipo '100').
 
: INIT_BTN ( -- )
    RESET_PIN ENABLE
    RESET_BTN UP SET_PULL
    RESET_BTN GPREN0 !
    RESET_BTN GPFEN0 ! ;
 
\ IS_CLICKED ( gpio --  )
\ Parola che permette di controllare se un evento è stato registrato per il pin associato. L'evento,
\ se esiste, viene scritto nel registro GPEDS0 al bit corrispondente dopo che viene rilevata una transizione
\ '010', motivo per cui devono essere stati abilitati i bit corrispondenti nei registri GPREN0 e GPFEN0.
 
: IS_CLICKED DUP >R GPEDS0 @ AND R> N_GPIO RSHIFT 0 = IF 0 ELSE 1 THEN ;
 
```

### main.f

Il file contiene il flusso sequenziale/logico di funzionamento del sistema. In esso sono definite le parole e le costanti necessarie al funzionamento del software secondo le modalità previste.

```

```

# Considerazioni Finali

Dopo una prima, lunga, fase di impostazione dell'attività progettuale, legata principalmente al reperimento della componentistica e all'apprendimento dell'ambiente di sviluppo (essendo la prima esperienza di programmazione a un così basso livello), possiamo affermare che la soluzione proposta rappresenti un punto di partenza per future espansioni e adattamenti a vari contesti, che vanno dalla domotica ad applicazioni industriali, in cui il rilevamento dei valori di temperatura e di umidità in tempo reale possa essere un *game-changer*.

In questo senso, possibili espansioni riguardano l'inserimento di attuatori e sensori che possano permettere alla soluzione di interfacciarsi con altri dispositivi e di fungere da regolatore del comportamento di questi ultimi, senza, peraltro, dover modificare il codice sorgente fin dove scritto: nel caso domestico, per esempio, si potrebbe pensare di centralizzare il controllo della temperatura aggiungendo pulsanti, per la determinazione dei valori desiderati, e altra componentistica, per permettere la comunicazione con le unità di controllo del clima (es. climatizzatori) e l'imposizione di tali valori fino al soddisfacimento di condizioni sia temporali che ambientali.

Inoltre, riteniamo che l'approccio seguito in fase di programmazione permetta al codice di poter essere riutilizzato anche su altri dispositivi target, semplicemente variando alcuni parametri di configurazione opportunamente astratti.

# References

[1] *"BCM2835 ARM Peripherals"*, Broadcom Corporation

[2] *"Specification For LCD Module 2004A"*, SHENZHEN EONE ELECTRONICS CO.

[3] *"PCF8574; PCF8574A Remote 8-bit I/O expander for I2C-bus with interrupt Rev. 5"*, NXP Microelectronics

[4] *"Digital relative humidity & temperature sensor AM2302/DHT22"*, Liu T.

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

# Bibliografia
