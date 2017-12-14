#!/bin/bash

#MSUB -r dtrend0
#MSUB -n 1
#MSUB -T 15000
#MSUB -q standard
#MSUB -o dtrend.o%I
#MSUB -e dtrend.e%I
#MSUB -A 


CONFIGCASE="NATL025.GSL301"
fityp="gridT"


echo 
./mk_trsp.sh > out_brk 

