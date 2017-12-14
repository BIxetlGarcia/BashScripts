import os
import numpy as np
import pandas as pd
import xarray as xr
import glob
import sys
import statsmodels.api as sm
lowess = sm.nonparametric.lowess
import scipy.interpolate as scpi
import time
from netCDF4 import num2date
from netCDF4 import Dataset as NetCDFFile 

pathi='/ccc/scratch/cont003/gen0727/garciagi/'
patho='/ccc/scratch/cont003/gen0727/garciagi/outtrends/'
mfiles=sorted(glob.glob(pathi+'1d/*.nc'))
trhfiles=sorted(glob.glob(pathi+'outtrends/SPLINES/splinesH*'))
trtfiles=sorted(glob.glob(pathi+'outtrends/SPLINES/splinesT*'))
print(len(mfiles),len(trtfiles),len(trhfiles))
mem=sys.argv[1]

membs=[int(mem)]
for im in range(len(membs)):
  ifens=membs[im]
  idmem=ifens+1
  #print(ifens)
  mean_file=mfiles[ifens]
  print(mean_file)
  dsem = xr.open_dataset(mean_file)
  linest=np.load(trtfiles[ifens])
  linesh=np.load(trhfiles[ifens])  
  print(trtfiles[ifens],trhfiles[ifens])
  time2=dsem.time_centered
  timet = pd.date_range('1993-01-01','2012-12-26' , freq='D')
  #print(time2.shape,timet.shape,timet2.shape)
  nt,ni,nj=dsem.ssh.shape
  ####Declare the NETCDF file
  meanM= NetCDFFile(patho+'outdetrend/GOM025.GSL301_m0%s_1d_dtrend.nc' %(idmem), 'w', format='NETCDF3_64BIT')

  meanM.createDimension('time_counter', nt)
  meanM.createDimension('y', ni)
  meanM.createDimension('x', nj)   

  #time_center = meanM.createVariable('time_center', 'f4', ('time_counter',))
  lons  = meanM.createVariable('lons','f4',('y','x'))
  lats  = meanM.createVariable('lats','f4',('y','x'))
 
  sshd  = meanM.createVariable('sshd', 'f4', ('time_counter', 'y','x'))
  sstd  = meanM.createVariable('sstd', 'f4', ('time_counter', 'y','x'))
  timet2 = pd.date_range('1993-01-01','2012-12-26' , freq='D')
              
  nt,ni,nj=dsem.ssh.shape
  print(nt,ni,nj)
  nt2=nt-(292*5+1)
  sshtr=np.ones([nt,ni,nj])
  sshtr[:]=np.NaN
  ssttr=np.ones([nt,ni,nj])
  ssttr[:]=np.NaN
  #tremh=np.ones([nt,ni,nj])
  #start1=time.clock()
  for ii in range(ni):
      print "Start ii:", ii
      for jj in range(nj):
          #print "jj:", jj
          xh=dsem.ssh[:,ii,jj]
          xt=dsem.sst[:,ii,jj]
          #treh=linesh[ii,jj]
          #tret=linest[ii,jj]  
          #xh=dsem.ssh[292*5+1:,ii,jj]
          #xt=dsem.sst[:,ii,jj]
          start2=time.clock()
          if np.isnan(xh[100]):
             tremh=np.ones(len(timet2))
             tremh[:]=np.NaN
             tremt=np.ones(len(timet2))
             tremt[:]=np.NaN
             pass
          else:
             #start2=time.clock()
             #shm=xh.resample('M',dim='time_counter',how='mean')
             #print(time.clock()-start2
             #print(xt.shape,xh.shape,timet2.shape)
             treh=linesh[ii,jj]
             #print(ii,jj,'treh ',time.clock()-start2)
             tret=linest[ii,jj]
             #print('tret',time.clock()-start2)
             tremh=treh(timet2.to_julian_date())
             #print('trem',time.clock()-start2)
             tremt=tret(timet2.to_julian_date())
             #print('tremt',time.clock()-start2)
             #start2=time.clock()

             sshtr[:,ii,jj]=xh-tremh
             #print(ii,jj,'sshtr',time.clock()-start2)
             ssttr[:,ii,jj]=xt-tremt
          #print('sstr',time.clock()-start2)
      
      #print(time.clock()-start1)
      #print(ii)
  lons[:,:]=dsem.nav_lon.data
  lats[:,:]=dsem.nav_lat.data
  #time_center[:]=time2
  sshd[:,:,:]=sshtr
  sstd[:,:,:]=ssttr
  #print(ifens)
  meanM.close()  
