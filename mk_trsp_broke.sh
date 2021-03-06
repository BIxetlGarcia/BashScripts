#!/bin/bash

##########test 2 of the CDFTOOLS and bash scripts####
echo 'module unload python'

CONFIGCASE="NATL025-GSL301"
dirg='/ccc/scratch//garciagi'
dirw='/ccc/work//garciagi/pruebas/test_broke'
#diri='/ccc/scratch//garciagi/tests'
diri='/ccc/scratch//molines/NATL025' #NATL025-GSL301.001-S/5d/1993'
diro='/ccc/scratch//garciagi/SECTIONS'
#mkdir ${diri}/testout
##################################################
##for each member, first one
#for MM in $(seq -f '%02g' 04 08);do
  MM='02'
  sect='FLO2'
  sec='FS2'
  # For each year, first one year
  for Y in $(seq  1993 2012); do

  #Y=1999
  ## for each file 
   cd ${diro}/${Y}/${MM}
   mkdir tempT
   it=1
   for fileu in $(ls ${sect}.*.nc); do
     #mkdir ${diro}/${Y}/${MM}  
     echo ${fileu}
     ## necessary files
     echo ${it}
     cd ${dirw}

     fileYU=$(echo ${fileu} | sed "s/brokeline/TtrpU/g" )
     fileYM=$(echo ${fileu} | sed "s/brokeline/TtrpM/g" )
     fileYB=$(echo ${fileu} | sed "s/brokeline/TtrpT/g" )

     ##transport calcules
     #cdfsigtrp -brk  ${diro}/${Y}/${MM}/${fileu} -smin 10 -smax 32  -nbins 44  -temp 
     #mv brokeline_trptemp.nc  ${diro}/${Y}/${MM}/tempT/${fileYU}
     #echo ${diro}/${Y}/${MM}/tempT/${fileYU}

     #cdfsigtrp -brk  ${diro}/${Y}/${MM}/${fileu} -smin 0 -smax 10 -nbins 200  -temp
     #cp brokeline_trptemp.nc  ${diro}/${Y}/${MM}/tempT/${fileYM}
     #echo ${diro}/${Y}/${MM}/tempT/${fileYM}


     cdfsigtrp -brk  ${diro}/${Y}/${MM}/${fileu} -smin 0 -smax 32 -nbins 640  -temp
     cp brokeline_trptemp.nc  ${diro}/${Y}/${MM}/tempT/${fileYB}
     echo ${diro}/${Y}/${MM}/tempT/${fileYB}

    it=$((it+1))
   done #cycle finish per every timestep
 
   #ncrcat ${diro}/${Y}/${MM}/tempT/${sect}.0${MM}*TtrpU.nc  ${diro}/${Y}/${MM}/tempT/${sec}.0${MM}_y${Y}.5d_TtrpU.nc
   #ncrcat ${diro}/${Y}/${MM}/tempT/${sect}.0${MM}*TtrpM.nc  ${diro}/${Y}/${MM}/tempT/${sec}.0${MM}_y${Y}.5d_TtrpM.nc
   ncrcat ${diro}/${Y}/${MM}/tempT/${sect}.0${MM}*TtrpT.nc  ${diro}/${Y}/${MM}/tempT/${sec}.0${MM}_y${Y}.5d_TtrpT.nc
  done #cycle finish per year
#done #cycle finish per member 
