#!/bin/bash

#MSUB -r dtrend2
#MSUB -n 1
#MSUB -T 50400
#MSUB -q standard
#MSUB -o dtrend.o%I
#MSUB -e dtrend.e%I
#MSUB -A gen0727


CONFIGCASE="NATL025.GSL301"
fityp="gridT"
diri='/ccc/scratch/cont003/gen0727/garciagi/1d'


for mem in {33..47}
do
echo mem: ${mem}
python ssh_detrend.py ${mem}
done
