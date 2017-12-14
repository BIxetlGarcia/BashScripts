##########test 2 of the DFTOOLS and bash scripts####
echo 'module unload python'

CONFIGCASE="NATL025-GSL301"
dirg='/ccc/scratch/cont003/gen0727/garciagi'
dirw='/ccc/work/cont003/gen0727/garciagi/pruebas/test_broke'
#diri='/ccc/scratch/cont003/gen0727/garciagi/tests'
diri='/ccc/scratch/cont003/gen0727/molines/NATL025' #NATL025-GSL301.001-S/5d/1993'
diro='/ccc/scratch/cont003/gen0727/garciagi/SECTIONS'
#mkdir ${diri}/testout
##################################################
##for each member, first one
MM='19'

# For each year, first one year
for Y in $(seq  1993 2012); do

#Y=1993
## for each file 
 cd ${diro}/${Y}/${MM}
 #mkdir tempT
 it=1
 for fileu in $(ls YUC.*.nc); do
  #mkdir ${diro}/${Y}/${MM}  
   echo ${fileu}
   ## necessary files
   echo ${it}
   cd ${dirw}

   fileYU=$(echo ${fileu} | sed "s/brokeline/StrpU/g" )
   fileYM=$(echo ${fileu} | sed "s/brokeline/StrpM/g" )
   fileYB=$(echo ${fileu} | sed "s/brokeline/StrpB/g" )

   ##transport calcules
   cdfsigtrp -brk  ${diro}/${Y}/${MM}/${fileu} -smin 20  -smax 26   -nbins 24   
   cp brokeline_trpsig.nc  ${diro}/${Y}/${MM}/tempT/${fileYU}
   echo ${diro}/${Y}/${MM}/tempT/${fileYU}

   cdfsigtrp -brk  ${diro}/${Y}/${MM}/${fileu} -smin 26 -smax 29 -nbins 150 
   cp brokeline_trpsig.nc  ${diro}/${Y}/${MM}/tempT/${fileYM}
   echo ${diro}/${Y}/${MM}/tempT/${fileYM}

   #cdfsigtrp -brk  ${diro}/${Y}/${MM}/${fileu} -smin 0 -smax 5 -nbins 5  -temp
   #cp brokeline_trptemp.nc  ${diro}/${Y}/${MM}/tempT/${fileYB}
   #echo ${diro}/${Y}/${MM}/tempT/${fileYB}

  it=$((it+1))
 done #cycle finish per every timestep
 
 ncrcat ${diro}/${Y}/${MM}/tempT/YUC.0${MM}*StrpU.nc  ${diro}/${Y}/${MM}/tempT/YC.0${MM}_y${Y}.5d_StrpU.nc
 ncrcat ${diro}/${Y}/${MM}/tempT/YUC.0${MM}*StrpM.nc  ${diro}/${Y}/${MM}/tempT/YC.0${MM}_y${Y}.5d_StrpM.nc
# ncrcat ${diro}/${Y}/${MM}/tempT/YUC.0${MM}*B.nc  ${diro}/${Y}/${MM}/tempT/FS2.0${MM}_y${Y}.5d_TemptrpB.nc
#echo ls  ${diro}/${Y}/${MM}/tempT/YC.*
done 
