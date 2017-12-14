#!/bin/bash

#MSUB -r census1
#MSUB -n 1
#MSUB -T 86400
#MSUB -q standard
#MSUB -o census.o%I
#MSUB -e census.e%I
#MSUB -A gen0727


CONFIGCASE="NATL025.GSL301"
fityp="gridT"
diri='/ccc/scratch/cont003/gen0727/garciagi/1d'


echo 
./mk_census2.sh > out_census2 

