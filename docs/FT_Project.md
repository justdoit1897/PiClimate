# BM - Termostato (Nome Provvisorio)

## Descrizione del progetto

Il progetto nasce per definire, in forma embrionale, un sistema di gestione del clima in ambienti chiusi. Il sistema target scelto è un **Raspberry&trade; Pi**, nella sua variante 1B, attraverso cui viene visualizzata, in modo continuato nel tempo, la condizione climatica dell'ambiente in cui ci si trova.

## Componenti Hardware

Per la realizzazione di questo progetto, sono stati necessari:
1. Raspberry Pi 1B
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
* PC con distribuzione Linux (Ubuntu) con installato G-Forth e Minicom;
* Interprete FORTH per soluzioni bare-metal pijFORTHos (via *https://github.com/organix/pijFORTHos*)
