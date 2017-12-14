#!/bin/bash

CONFIGCASE="NATL025-GSL301"
dirg='garciagi'

#dirw='garciagi/pruebas'
#diri='/garciagi/tests'
diri='//NATL025' #NATL025-GSL301.001-S/5d/1993'
dirw='/garciagi/test_brkl'

endcase='.5d_section.nc'
MM=49
#for MM in $(seq -f '%02g' 01 50);do
    
    fYC=${CONFIGCASE}.0${MM}_y1993_y2012.YC${endcase}
    fFS=${CONFIGCASE}.0${MM}_y1993_y2012.FS${endcase}
    fFS2=${CONFIGCASE}.0${MM}_y1993_y2012.FS2${endcase}
    fBH=${CONFIGCASE}.0${MM}_y1993_y2012.BH${endcase}    

    ncrcat YC/temp/${CONFIGCASE}.0${MM}_y*.YC${endcase}    YC/${fYC} 
    ncrcat FS/temp/${CONFIGCASE}.0${MM}_y*.FS${endcase}    FS/${fFS}
    ncrcat FS/temp2/${CONFIGCASE}.0${MM}_y*.FS2${endcase}  FS/${fFS2}
    ncrcat BH/temp/${CONFIGCASE}.0${MM}_y*.BH${endcase}    BH/${fBH}


#done
