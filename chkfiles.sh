#!/bin/bash

CONFIGCASE="NATL025-GSL301"
dirg='/garciagi'

#dirw='/garciagi/pruebas'
#diri='garciagi/tests'
diri='NATL025-GSL301.001-S/5d/1993'
dirw='/garciagi/test_brkl'

endcase='.5d_section.nc'
#Y=1998
for Y in $(seq 1993 2012);do
  cd ${dirw}/${Y}/
  ls -l |grep ^d| wc -l
  echo ${Y} 
  for MM in $(seq -f '%02g' 01 50);do
     #echo ${MM}
   if [ -d ${MM} ]
     then
      #echo ${MM} exists
      cd ${dirw}/${Y}/${MM}/
      fYC=YC.0${MM}_y${Y}${endcase}
      fFS=FS.0${MM}_y${Y}${endcase}
      fFS2=FS2.0${MM}_y${Y}${endcase}
      fBH=BH.0${MM}_y${Y}${endcase}
      #echo ${fYC}
      if [ -f ${fYC} -a -f ${fFS} -a -f ${fFS2} -a -f ${fBH} ]
         then
          echo  'files exist in' ${MM} 
      fi

      if [ -f ${fYC}*.tmp -o -f ${fFS}*.tmp -o -f ${fFS2}*.tmp -o -f ${fBH}*.tmp ]
        then
        echo 'Error in ncrcat'
        echo ${Y}/${MM}
        #wait 3
      fi

      cd ..
   fi
   if [ ! -d ${MM} ]
     then
     echo  ${MM} 'WARNING not exists'

