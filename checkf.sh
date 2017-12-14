#!/bin/bash

CONFIGCASE="NATL025-GSL301"
dirg='/ccc/scratch/cont003/gen0727/garciagi'

#dirw='/ccc/work/cont003/gen0727/garciagi/pruebas'
#diri='/ccc/scratch/cont003/gen0727/garciagi/tests'
diri='/ccc/scratch/cont003/gen0727/molines/NATL025' #NATL025-GSL301.001-S/5d/1993'
dirw='/ccc/scratch/cont003/gen0727/garciagi/SECTIONS'

endcase='.5d_section.nc'
#Y=1998
nf=73
for Y in $(seq 1993 2012);do
 cd ${dirw}/${Y}/
 fy=$(ls -l |grep ^d| wc -l)
  echo ${Y}
  echo ${fy} 
  #for MM in $(seq -f '%02g' 01 50);do
     MM=19
     #echo ${MM}
   if [ -d ${MM} ]
     then
      #echo ${MM} exists
      cd ${dirw}/${Y}/${MM}/
      fmm=$(ls -l YUC2* |grep ^-| wc -l)
      fmm2=$(ls -l FLO2* |grep ^-| wc -l)
      fmm3=$(ls -l BAH2* |grep ^-| wc -l)
      if [ ${fmm} != ${nf} ]
      then 
      echo Warning  dif number of files ${Y}/${MM}
      fi

      fYC=YC.0${MM}_y${Y}${endcase}
      fYC2=YC2.0${MM}_y${Y}${endcase}
      fFS=FS.0${MM}_y${Y}${endcase}
      fFS2=FS2.0${MM}_y${Y}${endcase}
      fBH=BH.0${MM}_y${Y}${endcase}
      fBH2=BH2.0${MM}_y${Y}${endcase}
      #echo ${fYC}
      if [ -f ${fYC} -a -f ${fYC2}  -a -f ${fFS} -a -f ${fFS2} -a -f ${fBH} -a -f ${fBH2}  ]
         then
          echo  'files exist in' ${MM} 
      fi

      if [ -f ${fYC}*.tmp  -o -f ${fYC2}*.tmp -o -f ${fFS}*.tmp -o -f ${fFS2}*.tmp -o -f ${fBH}*.tmp  -o -f ${fBH2}*.tmp ]
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
   fi
  #done
done 
