#!/bin/bash

CONFIGCASE="NATL025-GSL301"
dirg='/garciagi'

dirw='/garciagi/SECTIONS'

endcase='.5d_section.nc'

Y=1999
#for Y in $(seq 1993 2012);do
  cd ${dirw}/${Y}/
MM=49
  #for MM in $(seq -f '%02g' 01 50);do
    cd ${dirw}/${Y}/${MM}/
    fYC=YC.0${MM}_y${Y}${endcase}
    fFS=FS.0${MM}_y${Y}${endcase}
    fFS2=FS2.0${MM}_y${Y}${endcase}
    fBH=BH.0${MM}_y${Y}${endcase}
    
    cp ${fYC} ../../YC/temp/${CONFIGCASE}.0${MM}_y${Y}.YC${endcase}
    cp ${fFS} ../../FS/temp/${CONFIGCASE}.0${MM}_y${Y}.FS${endcase}
    cp ${fFS2} ../../FS/temp2/${CONFIGCASE}.0${MM}_y${Y}.FS2${endcase}
    cp ${fBH} ../../BH/temp/${CONFIGCASE}.0${MM}_y${Y}.BH${endcase}
    #echo 'files copied'
    echo ${MM}
    cd ..
  
  #done
  echo 'files copied of ' ${Y}
#done

