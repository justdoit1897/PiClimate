#!/bin/bash

DEVICE=/dev/ttyUSB0 
BAUD=115200            

sudo picocom -b $BAUD -r -l $DEVICE --imap delbs -s "ascii-xfr -sv -l100 -c10"

