#!/bin/bash

#MSUB -r MMBMEAN
#MSUB -n 1
#MSUB -T 21600
#MSUB -q standard
#MSUB -o MMBMEAN.o%I
#MSUB -e MMBMEAN.e%I
#MSUB -A gen0727

diro='/ccc/scratch/cont003/gen0727/garciagi/1d'
dirw='/ccc/work/cont003/gen0727/garciagi/pruebas'
python ${dirw}/ssh_mean_sh.py > outsssh
python ${dirw}/ssh_mean_shf.py >outssst
