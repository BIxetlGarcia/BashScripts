#!/bin/bash
#MSUB -r quantile
#MSUB -n 1
#MSUB -T 36000
#MSUB -q standard
#MSUB -o zquantile.o%I
#MSUB -e zquantile.e%I
#MSUB -A gen0727
#MSUB -E "--exclusive"

CONFIGCASE="GOM025.GSL301"
fityp="diff"
diri='/ccc/scratch/cont003/gen0727/garciagi/SEASONAL/TEMP'
module unload python
./cdfquantiles -l ${diri}/${CONFIGCASE}_m0*_H_${fityp}.nc -var ssht -box 1 -o ${diri}/GOMDSEAS -q 10


