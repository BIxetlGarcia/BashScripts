#!/bin/bash
#MSUB -r quantilef
#MSUB -n 1
#MSUB -T 36000
#MSUB -q standard
#MSUB -o zquantilef.o%I
#MSUB -e zquantilef.e%I
#MSUB -A gen0727

CONFIGCASE="GOM025.GSL301"
fityp="filt"
diri='/ccc/scratch/cont003/gen0727/garciagi/FILTER'
module unload python 
./cdfquantiles -l ${diri}/${CONFIGCASE}_m0*_H_${fityp}.nc -var ssht  -o GOMLF -q 5 



