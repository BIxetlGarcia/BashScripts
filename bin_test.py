#!/usr/bin/env python

import xarray as xr
import numpy as np
#import timing
import sys

memb=sys.argv[1]
#yr=sys.argv[2]

estr=str(memb).zfill(3)

datadir='/ccc/scratch/cont003/gen0727/garciagi/DETREND/'
homedir=''
outdir='/ccc/scratch/cont003/gen0727/garciagi/DETREND/TEMP/'
#outdir=homedir

#fname="ORCA025.L75-OCCITENS."+estr+"_y"+str(yr)+".5d_ssha.nc"
fname='GOM025.GSL301_m'+estr+'_1d_dtrend.nc'
print(fname)
#with xr.open_dataset(homedir+'lonlat.nc') as fic:
    #lon=fic.nav_lon.values
    #lat=fic.nav_lat.values

#can't deal with NaN so set to value outside of bin range so that they don't get considered
#ssh[np.where(np.isnan(ssh))]=-9999
##quantiles for the file
qfile=xr.open_dataset(datadir+'quantiles010_ssht.nc')
#bwidth=0.05
#brange=np.arange(-200,201,bwidth*1e2)*1e-2
#bhalf=bwidth*0.5
quantiles=qfile.quantile.values
brange=quantiles
print(quantiles.shape)
with xr.open_dataset(datadir+fname) as fic:
    ssh=fic.ssht.values
    lon=fic.lons.values
    lat=fic.lats.values

nt,ny,nx=ssh.shape
nq=quantiles.shape

binned=np.zeros((nq[0],nt,ny,nx))
print(binned.shape)
    #ssh[np.where(np.isnan(ssh))]=-9999

work=np.zeros(np.shape(ssh))
    
for i in range(len(brange)):
        ix,iy,iz=np.where((ssh >= brange[i]-bhalf) & \
                              (ssh < brange[i]+bhalf))
        work[ix,iy,iz]=1
        binned[i,:,:,:]=work
        work=work*0

#create xarray dataset
fic=xr.Dataset({'bin_counts': (['quant','time_counter','y','x'], binned)},
               coords={'nav_lon': (['y','x'],lon),
                       'nav_lat': (['y','x'],lat),
                       'quantile': (['quant','y','x'],brange)})
fic.to_netcdf(outdir+'GOM025.GS301_m'+estr+'_binned.nc')
fic.close()
