#!/bin/bash

#MSUB -r dtrend0
#MSUB -n 1
#MSUB -T 50400
#MSUB -q standard
#MSUB -o dtrend.o%I
#MSUB -e dtrend.e%I
#MSUB -A 


CONFIGCASE="NATL025.GSL301"
fityp="gridT"


for mem in {5..18}
do
echo mem: ${mem}
python ssh_detrend.py ${mem}
done
