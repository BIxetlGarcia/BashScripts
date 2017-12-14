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

pathi='/ccc/scratch/cont003/gen0727/garciagi/1d'
patho='/ccc/scratch/cont003/gen0727/garciagi/outtrends'
mfiles=sorted(glob.glob(pathi+'/*.nc'))
#print(len(mfiles))
mem=sys.argv[1]

membs=[int(mem)]
for im in range(len(membs)):
  ifens=membs[im]
  #print(ifens)
  mean_file=mfiles[ifens]
  #print(mean_file)
  dsem = xr.open_dataset(mean_file)
  time2=dsem.time_centered[292*5+1:]
  timet = pd.date_range('1993-01-01','2012-12-26' , freq='D')
  timet2 = pd.date_range('1993-01-01','2012-12-26' , freq='MS')
  #print(time2.shape,timet.shape,timet2.shape)

              
  nt,ni,nj=dsem.ssh.shape
  #print(nt,ni,nj)
  nt2=nt-(292*5+1)
  htrend=np.ones([ni,nj],dtype='object')
  ttrend=np.ones([ni,nj],dtype='object')
  start1=time.clock()
  sh=dsem.ssh.resample('M',dim='time_counter',how='mean')
  st=dsem.sst.resample('M',dim='time_counter',how='mean')
  #print(time.clock()-start1)
  #print(htrend.shape)
  #for ii in range(ni):
  #    for jj in range(nj):
  for ii in range(ni):
      #print "Start ii:", ii
      for jj in range(nj):
          #print "jj:", jj
          xh=sh[:,ii,jj]
          xt=st[:,ii,jj]  
          #xh=dsem.ssh[292*5+1:,ii,jj]
          #xt=dsem.sst[:,ii,jj]
          if np.isnan(xh[100]):
             tremh=np.ones(len(timet2))
             tremh[:]=np.NaN
             tremt=np.ones(len(timet2))
             tremt[:]=np.NaN
             pass
          else:
             start1=time.clock()
             #shm=xh.resample('M',dim='time_counter',how='mean')
             #print(time.clock()-start1
             #print(xt.shape,xh.shape,timet2.shape)
             tremh=lowess(xh,timet2.to_julian_date(),frac=0.6,return_sorted=False)
             #print(time.clock()-start1)
             #start2=time.clock()
             #stm=xt.resample('M',dim='time_counter',how='mean')
             tremt=lowess(xt,timet2.to_julian_date(),frac=0.6,return_sorted=False)
             #print(time.clock()-start2)
             #print(time.clock()-start1)

          funh=scpi.UnivariateSpline(timet2.to_julian_date(),tremh,k=5)
          htrend[ii,jj]=funh
          funt=scpi.UnivariateSpline(timet2.to_julian_date(),tremt,k=5)
          ttrend[ii,jj]=funt


      #print(ii)
        

  np.save(patho+'/splinesH_%s' %ifens,htrend)
  np.save(patho+'/splinesT_%s' %ifens,ttrend)
  #print(ifens)  
