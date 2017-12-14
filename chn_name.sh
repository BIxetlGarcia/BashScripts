#!/bin/bash

#MSUB -r MKMMB
#MSUB -n 1
#MSUB -T 42000
#MSUB -q standard
#MSUB -o MKMMB.o%I
#MSUB -e MKMMB.e%I
#MSUB -A gen0727


CONFIGCASE="NATL025.GSL301"
fityp="gridT"
diri='/ccc/scratch/cont003/gen0727/garciagi/outtrends'
diro='/ccc/scratch/cont003/gen0727/garciagi/outtrends/test'
#$(seq -f "%03g"  001 050 )
ii=0
for m in $(seq -f "%03g"  001 050 ) ; do
 echo ${ii}
 echo ${diri}/splinesH_${ii}.npy
 cp ${diri}/splinesT_${ii}.npy ${diro}/splinesT_${m}.npy
 ii=$((ii+1))
 echo ${m}
done
