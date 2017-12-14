#!/bin/bash

#MSUB -r dtrendT
#MSUB -n 1
#MSUB -T 21600
#MSUB -q standard
#MSUB -o dtrendT.o%I
#MSUB -e dtrendT.e%I
#MSUB -A gen0727


CONFIGCASE="NATL025.GSL301"
fityp="gridT"
diri='/ccc/scratch/cont003/gen0727/garciagi/1d'

mem=49
#for mem in {19..32}
#do
echo mem: ${mem}
python ssh_demap.py ${mem}
#done
