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
diri='/ccc/scratch/cont003/gen0727/garciagi/1d'

#$(seq -f "%03g"  001 050 )

for m in $(seq -f "%03g"  001 050 ) ; do
 echo ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}.nc
 nccopy -k  2  ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}.nc  ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}_toto2.nc
 ncecat ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}_toto2.nc ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}_titi2.nc
 ncrename -d record,member ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}_titi2.nc
 ncks -A ${diri}/titi.${m}.nc ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}_titi2.nc

done
