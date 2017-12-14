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
MM='49'

# For each year, first one year
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
  fileY=$(echo ${fileu} | sed "s/gridU/brokeline/g" | sed "s/${CONFIGCASE}/YUC/g")
  fileF=$(echo ${fileu} | sed "s/gridU/brokeline/g" | sed "s/${CONFIGCASE}/FLO1/g")
  fileF2=$(echo ${fileu} | sed "s/gridU/brokeline/g" | sed "s/${CONFIGCASE}/FLO2/g")
  fileB=$(echo ${fileu} | sed "s/gridU/brokeline/g" | sed "s/${CONFIGCASE}/BAH/g")

echo ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${fileY}

##transport calcules
  cdf_xtrac_brokenline -t  ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${filet}  -u ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${fileu} -v ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${filev} -mxl ${diri}/${CONFIGCASE}.0${MM}-S/5d/${Y}/${filefx} -f sec_YC.txt,sec_FS.txt,sec_FS2.txt,sec_BH.txt -ssh -vt -mld -vecrot
  
  #mkdir ${diro}/${Y}/${MM}
  echo ${diro}/${Y}/${MM}
  cp YC.nc ${diro}/${Y}/${MM}/${fileY}
  cp FS2.nc ${diro}/${Y}/${MM}/${fileF2}
  cp FS.nc ${diro}/${Y}/${MM}/${fileF}
  cp BH.nc ${diro}/${Y}/${MM}/${fileB} 
  it=$((it+1))
  rm -f YC.nc
  rm -f FS2.nc
  rm -f FS.nc
  rm -f BH.nc 
 done #cycle finish per every timestep
 
 ncrcat ${diro}/${Y}/${MM}/YUC.0${MM}*  ${diro}/${Y}/${MM}/YC.0${MM}_y${Y}.5d_section.nc
 ncrcat ${diro}/${Y}/${MM}/FLO1.0${MM}*  ${diro}/${Y}/${MM}/FS.0${MM}_y${Y}.5d_section.nc
 ncrcat ${diro}/${Y}/${MM}/FLO2.0${MM}*  ${diro}/${Y}/${MM}/FS2.0${MM}_y${Y}.5d_section.nc
 ncrcat ${diro}/${Y}/${MM}/BAH.0${MM}*  ${diro}/${Y}/${MM}/BH.0${MM}_y${Y}.5d_section.nc
 echo ${diro}/${Y}/${MM}/FS2.0${MM}_y${Y}.5d_section.nc
#done 
