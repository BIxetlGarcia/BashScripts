##############The firt test of CDFTOOLS
CONFIGCASE="NATL025-GSL301"
diri='/ccc/scratch/cont003/gen0727/garciagi/'


ln -sf "/ccc/work/cont003/gen0727/garciagi/NATL025/NATL025-I/NATL025-CJMenobs01_byte_mask.nc" mask.nc
ln -sf "/ccc/work/cont003/gen0727/garciagi/NATL025/NATL025-I/NATL025-CJMenobs01_mesh_hgr.nc" mesh_hgr.nc
ln -sf "/ccc/work/cont003/gen0727/garciagi/NATL025/NATL025-I/NATL025-CJMenobs01_mesh_zgr.nc" mesh_zgr.nc

cdfvT ${diri}/${CONFIGCASE}.003  'y2005m07d01.5d'  
