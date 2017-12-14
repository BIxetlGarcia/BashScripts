#!/bin/bash

##########test CDFTOOLS and bash scripts: brokenline####
echo 'module unload python'

CONFIGCASE="NATL025-GSL301"
dirg='/garciagi'
dirw='/garciagi/pruebas'
#diri='/scratch//garciagi/tests'
diro='/ccc/scratch//garciagi/test_brkl'
#mkdir ${diri}/testout
##################################################
##for each member, first one
MM='49'
it=0
# For each year, first one year
for Y in $(seq 1999 ); do

## for each file 
 cd ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}
 for fileu in $(ls *5d_gridU.nc); do
  #echo ${fileu}
  ## necessary files
  echo ${it}
  cd ${dirw}

  filev=$(echo ${fileu} | sed "s/gridU/gridV/g")
  fileY=$(echo ${fileu} | sed "s/gridU/transport/g" | sed "s/${CONFIGCASE}/YUC/g")
  fileF=$(echo ${fileu} | sed "s/gridU/transport/g" | sed "s/${CONFIGCASE}/FLO/g")
  fileB=$(echo ${fileu} | sed "s/gridU/transport/g" | sed "s/${CONFIGCASE}/BAH/g")

#echo ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${fileY}

##transport calcules
  cdftransport -noheat  ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${fileu}  ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${filev}   <${dirg}/sectionf.dat

  cp 01_YUCATAN_transports.nc ${diro}/${Y}/${fileY}

  cp 02_FLORIDA_transports.nc ${diro}/${Y}/${fileF}
  cp 03_BAHAMAS_transports.nc ${diro}/${Y}/${fileB} 
  it=it+1

 done #cycle finish per every timestep
 
 ncrcat ${diro}/${Y}/YUC*  ${diro}/${Y}/YUC.0${MM}_y${Y}.5d_transport.nc
 ncrcat ${diro}/${Y}/FLO*  ${diro}/${Y}/FLO.0${MM}_y${Y}.5d_transport.nc
 ncrcat ${diro}/${Y}/BAH*  ${diro}/${Y}/BAH.0${MM}_y${Y}.5d_transport.nc
 
done 
