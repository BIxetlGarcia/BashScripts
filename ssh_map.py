
# coding: utf-8

# In[1]:

import os
import numpy as np
import pandas as pd
import xarray as xr
import glob
#import matplotlib.pyplot as plt
#get_ipython().magic(u'matplotlib inline')
#from matplotlib import animation
#import cartopy.crs as ccrs
from scipy.io import netcdf
#from scipy import signal
from netCDF4 import num2date
from netCDF4 import Dataset as NetCDFFile 
import matplotlib.dates as mdates
#from mpl_toolkits.basemap import Basemap
import datetime
#from wavelets import WaveletAnalysis


# In[2]:

path='/ccc/scratch/cont003/gen0727/garciagi'
#mfiles=  'GOM025-GSL301.050_y1993-2012.1d_gridT.nc','GOM025-GSL301.001_y1993-2012.1d_gridT.nc'
#print(len(filenames))


# In[3]:


mfiles=sorted(glob.glob(path+'/1d/*1d_gridT.nc'))
print(len(mfiles))
#In[32]
def clim_st2(smean,yi):
    
    if yi==1997:
        l=1
        fy=14
        ny=15
        diy=[365,365,365,366,365,365,365,366,365,365,365,366,365,365,365,366]
        years=[1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012]
    else:
        l=0
        fy=18
        ny=19
        diy=[365,365,365,366,365,365,365,366,365,365,365,366,365,365,365,366,365,365,365,366]
        years=[1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012]
        
    #print(len(diy),len(years))
    csdiy=np.cumsum(diy)
    dd=365
    smeassh=np.empty(len(smean))
    smeassh[:]=np.NaN
    smep=np.empty(len(smean))
    smep[:]=np.NaN
    #print(csdiy, smeassh.shape)
    for j in range(365):
        smeassh[l]=smean[l]
        smep[l]=smeassh[l]
        #print(smean[l],smeassh[l])
        for k in range(ny):
            #k=kl+1
            #print(l+csdiy[k])
            if l>59 and l<360:
                if k==2 or k==6 or k==10 or k==14 or k==18:

                    smeassh[l]=smeassh[l]+smean[l+csdiy[k]+1]
     
                else:

                    smeassh[l]=smeassh[l]+smean[l+csdiy[k]]
               
            elif l>359 and k==fy:
                smeassh[l]=smeassh[l]+smean[l+csdiy[k-1]+1]
                #print('final year is %s' %k)
            
            else:
            
            
                smeassh[l]=smeassh[l]+smean[l+csdiy[k]]
             
    
            dd=dd+1
        #print(j+csdiy[:-1])
        #if l<360:
            #smep[l+csdiy[:-1]]=smeassh[l]
            #smep[l]=smeassh[l]
            #print(smeassh[l],smep[l+csdiy[:-1]],l,j)
        #else:
            #smep[l+csdiy[:-2]]=smeassh[l]
            #smep[l]=smeassh[l]
            #print(smeassh[l],smep[l+csdiy[:-2]],l,j)
 
        l=l+1
        
    sme1=smeassh[:365]
    return (smep,sme1)

#In[4]:

ifens=28
mean_file=mfiles[ifens]
print(mean_file)
dsem = xr.open_dataset(mean_file)
#dsl=xr.open_dataset('/home/users/garcia8ix/workd/GOM_1D/GOM025-GSL301.041_y1993-2012.1d_gridT.nc')

lats=dsem.nav_lat
lons=dsem.nav_lon
time2=dsem.time_centered
time3 = pd.date_range('1993-01-01','2012-12-26' , freq='5D')


ntime=365#len(time2[:])
nrow=lats.shape[0]
ncols=lats.shape[1]            
              
meanM= NetCDFFile(path+'/testout/map_msc_%s.nc' %(ifens), 'w', format='NETCDF3_64BIT')

meanM.createDimension('time', ntime)
meanM.createDimension('y', nrow)
meanM.createDimension('x', ncols)   

#time = meanM.createVariable('time', 'f4', ('time',))
lats  = meanM.createVariable('lons','f4',('y','x'))
lons  = meanM.createVariable('lats','f4',('y','x'))
 
aclim  = meanM.createVariable('aclim', 'f4', ('time', 'y','x'))
tclim  = meanM.createVariable('tclim', 'f4', ('time', 'y','x'))
stm=np.zeros((len(time2[:]),lats.shape[0],lats.shape[1]))
stdm=np.zeros((len(time2[:]),lats.shape[0],lats.shape[1]))


nt,ni,nj=dsem.ssh.shape
print(nt,ni,nj)
aclm=np.ones([365,ni,nj])
tclm=np.ones([365,ni,nj])
print(aclim.shape)
for ii in range(ni):
    for jj in range(nj):
        xh=np.squeeze(dsem.ssh[:,ii,jj].data)
        #print(meanssh.shape)
        pclim,pclim2=clim_st2(xh[292*5:],1997)
        pclim=None
        aclm[:,ii,jj]=pclim2
        xt=np.squeeze(dsem.sst[:,ii,jj].data)
        #print(meanssh.shape)
        tclim1,tclim2=clim_st2(xt[292*5:],1997)
        tclim1=None
        tclm[:,ii,jj]=tclim2
        print(jj)

    print(ii)
        

        
    lons[:,:]=dsem.nav_lon.data
    lats[:,:]=dsem.nav_lat.data
        #xh=xh[292*5:]
        #time2e=dsem.time_centered[292*5:]
        #colorgr=(np.random.random(3))
        #axes4.plot(time2e,xh,color=colorgr,label='5 Days',linewidth=0.3)
        #ifens=ifens+1
        #dsem=None
        
aclim[:,:,:]=aclm
tclim[:,:,:]=tclm
meanM.close()
