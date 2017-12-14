#!/bin/bash

#MSUB -r census0
#MSUB -n 1
#MSUB -T 86400
#MSUB -q standard
#MSUB -o census.o%I
#MSUB -e census.e%I
#MSUB -A 


CONFIGCASE="NATL025.GSL301"
fityp="gridT"


echo 
./mk_census.sh > out_census 

