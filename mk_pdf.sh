#!/bin/bash
#MSUB -r pdf
#MSUB -n 1
#MSUB -T 36000
#MSUB -q standard
#MSUB -o zpdf.o%I
#MSUB -e zpdf.e%I
#MSUB -A gen0727
#MSUB -E "--exclusive"

module unload python
set -x
CONFIGCASE="GOM025.GSL301"
fityp="seas"
diri='/ccc/scratch/cont003/gen0727/garciagi/FILTER/'
cd ${diri}
./cdfquantilest_pdf -qf GOMLF_quantiles005_ssht.nc -l ${CONFIGCASE}_m0*.nc -m GOM025_mask.nc -var ssht
