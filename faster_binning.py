#!/usr/bin/env python

import xarray as xr
import numpy as np
import timing
import sys

memb=sys.argv[1]
yr=sys.argv[2]

estr=str(memb).zfill(3)

datadir="/ccc/store/cont003/gen0727/closes/ORCA025.L75/ssh/5day/anomaly/e"+estr+"/"
homedir="/ccc/cont003/home/gen0727/closes/"
outdir="/ccc/store/cont003/gen0727/closes/ORCA025.L75/ssh/5day/binned/e"+estr+"/"
#outdir=homedir

fname="ORCA025.L75-OCCITENS."+estr+"_y"+str(yr)+".5d_ssha.nc"

with xr.open_dataset(homedir+'lonlat.nc') as fic:
    lon=fic.nav_lon.values
    lat=fic.nav_lat.values

#can't deal with NaN so set to value outside of bin range so that they don't get considered
#ssh[np.where(np.isnan(ssh))]=-9999

bwidth=0.05
brange=np.arange(-200,201,bwidth*1e2)*1e-2
bhalf=bwidth*0.5

s=np.shape(lon)

binned=np.zeros((brange.size,s[0],s[1]))


with xr.open_dataset(datadir+fname) as fic:
    ssh=fic.ssh.values
    #ssh[np.where(np.isnan(ssh))]=-9999

work=np.zeros(np.shape(ssh))
    
for i in range(len(brange)):
        ix,iy,iz=np.where((ssh >= brange[i]-bhalf) & \
                              (ssh < brange[i]+bhalf))
        work[ix,iy,iz]=1
        binned[i,:,:]=np.sum(work,axis=0)
        work=work*0

#create xarray dataset
fic=xr.Dataset({'bin_counts': (['ssh','x','y'], binned)},
               coords={'nav_lon': (['x','y'],lon),
                       'nav_lat': (['x','y'],lat),
                       'ssh': brange})
fic.to_netcdf(outdir+'e'+estr+'_y'+str(yr)+'_binned.nc')
fic.close()
