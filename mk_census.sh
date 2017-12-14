#!/bin/bash

CONFIGCASE="NATL025-GSL301"
dirg='/ccc/scratch//garciagi'

diri='/ccc/scratch//NATL025' #NATL025-GSL301.001-S/5d/1993'
dirw='/ccc/scratch//garciagi/SECTIONS'

endcase='.5d_section.nc'

MM=31
#for MM in $(seq -f '%02g' 01 50);do
    fYC=YC.0${MM}_y${Y}${endcase}
    fFS=FS.0${MM}_y${Y}${endcase}
    fFS2=FS2.0${MM}_y${Y}${endcase}
    fBH=BH.0${MM}_y${Y}${endcase}
    
    
    #cdfcensus -t ${dirw}/FS/${CONFIGCASE}.0${MM}_y1993_y2012.FS${endcase} srange 33.5 37 0.02 -trange 5 33 0.05 -o ${dirw}//FS/${CONFIGCASE}.0${MM}_y1993_y2012.FS.5d_census.nc
    cdfcensus -t ${dirw}/FS/${CONFIGCASE}.0${MM}_y1993_y2012.FS2${endcase} -srange 33.5 37 0.02 -trange 5 33 0.05 -o ${dirw}//FS/${CONFIGCASE}.0${MM}_y1993_y2012.FS2.5d_census.nc
    echo ${MM}
  
#done

