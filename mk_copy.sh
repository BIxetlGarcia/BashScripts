#######
#!/bin/bash

CONFIGCASE="NATL025.GSL301"
fityp="gridT"
diri='/ccc/scratch//garciagi/1d'

#$(seq -f "%03g"  001 050 )

for m in $(seq -f "%03g"  001 002 ) ; do
 echo ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}.nc
 nccopy -k  2  ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}.nc  ${diri}/${CONFIGCASE}_m${m}.1d_${fityp}_toto2.nc

done
