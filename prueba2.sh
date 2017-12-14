##########test 2 of the DFTOOLS and bash scripts####
echo 'module unload python'

CONFIGCASE="NATL025-GSL301"
dirg='/ccc/scratch/cont003/gen0727/garciagi'

#diri='/ccc/scratch/cont003/gen0727/garciagi/tests'
diri='/ccc/scratch/cont003/gen0727/molines/NATL025' #NATL025-GSL301.001-S/5d/1993'
diro='/ccc/scratch/cont003/gen0727/garciagi/test_transp'
dirw='/ccc/work/cont003/gen0727/garciagi/pruebas/test_broke'
#mkdir ${diri}/testout
##################################################
# For each year, first one year

## for each month 
#M='06'
#D='26'
MM='21'
##Copying the necessary files
#ln -sf '/ccc/work/cont003/gen0727/garciagi/pruebas/vt.nc' ${diri}/${CONFIGCASE}.003_y${Y}m${M}d${D}.5d_vt.nc

#for Y in $(seq  2010 2011); do
Y=1999
## for each file 
 cd ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}
 it=1
 mkdir ${diro}/${Y}/${MM}
 for fileu in $(ls *5d_gridU.nc); do
  #mkdir ${diro}/${Y}/${MM}  
  echo ${fileu}
  ## necessary files
  echo ${it}
  cd ${dirw}

  filev=$(echo ${fileu} | sed "s/gridU/gridV/g")
  filet=$(echo ${fileu} | sed "s/gridU/gridT/g")
  filefx=$(echo ${fileu} | sed "s/gridU/flxT/g")
  fileY=$(echo ${fileu} | sed "s/gridU/transport/g" | sed "s/${CONFIGCASE}/YUC/g")
  fileF=$(echo ${fileu} | sed "s/gridU/brokeline/g" | sed "s/${CONFIGCASE}/FLO1/g")
  fileF2=$(echo ${fileu} | sed "s/gridU/brokeline/g" | sed "s/${CONFIGCASE}/FLO2/g")
  fileB=$(echo ${fileu} | sed "s/gridU/brokeline/g" | sed "s/${CONFIGCASE}/BAH/g")

  #echo ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${fileY}
  echo ${fileu}
  echo ${filev}
  pwd
  ## Calcules

  cdftransport -noheat -u ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${fileu}  -v ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${filev}  -zlimit 400 500 600 700 800 900 1000  <YC_section.dat

  cp 01_YC_transports.nc  ${diro}/${fileY}
  it=$((it+1))
done 

#cp 02_FLORIDA_transports.nc ${diro}/FLORIDA.0${MM}_y${Y}m${M}d${D}.5d_transport.nc
#cp 03_BAHAMAS_transports.nc ${diro}/BAHAMAS.0${MM}_y${Y}m${M}d${D}.5d_transport.nc 



