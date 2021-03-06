
# coding: utf-8

# In[1]:

import os
import numpy as np
import pandas as pd
import xarray as xr
import glob
import matplotlib.pyplot as plt
#get_ipython().magic(u'matplotlib inline')
#from matplotlib import animation
#import cartopy.crs as ccrs
from scipy.io import netcdf
from scipy import signal
from netCDF4 import num2date
from netCDF4 import Dataset as NetCDFFile 
import matplotlib.dates as mdates
#from mpl_toolkits.basemap import Basemap
import datetime
#from wavelets import WaveletAnalysis


# In[2]:

path='/home/users/garcia8ix/workd/'
#mfiles=  'GOM025-GSL301.050_y1993-2012.1d_gridT.nc','GOM025-GSL301.001_y1993-2012.1d_gridT.nc'
filenames=sorted(glob.glob('/home/users/garcia8ix/workd/ENTROPY/5-days-avg/*.nc'))
print(len(filenames))
meanfile='/home/users/garcia8ix/workd/ENTROPY/stats/Smean.nc'


# In[3]:


mfiles=sorted(glob.glob('/home/users/garcia8ix/workd/GOM_1D/*.nc'))
#mfiles=mfiles[0:25]
#dsh = xr.open_mfdataset(mfiles,concat_dim='ensemble')


# In[4]:

dsl=xr.open_dataset('/home/users/garcia8ix/workd/GOM_1D/GOM025-GSL301.041_y1993-2012.1d_gridT.nc')
mds=xr.open_dataset(meanfile)

lats=dsl.nav_lat
lons=dsl.nav_lon
time2=dsl.time_centered
time3 = pd.date_range('1993-01-01','2012-12-26' , freq='5D')

ifens=0
ntime=len(time2[:])
nrow=lats.shape[0]
ncols=lats.shape[1]            
              
meanS= NetCDFFile('meanSSTF.nc', 'w', format='NETCDF3_64BIT')

meanS.createDimension('time', ntime)
meanS.createDimension('y', nrow)
meanS.createDimension('x', ncols)   

time = meanS.createVariable('time', 'f4', ('time',))
lats  = meanS.createVariable('lons','f4',('y','x'))
lons  = meanS.createVariable('lats','f4',('y','x'))
 
meansst  = meanS.createVariable('meansst', 'f4', ('time', 'y','x'))
stdsst  = meanS.createVariable('stdsst', 'f4', ('time', 'y','x'))
stdsst2  = meanS.createVariable('stdsst2', 'f4', ('time', 'y','x'))
mlo=[1] 
stm=np.zeros((len(time2[:]),lats.shape[0],lats.shape[1]))
stdm=np.zeros((len(time2[:]),lats.shape[0],lats.shape[1]))

for item in mfiles:
    mean_file=mfiles[ifens]
    dsem = xr.open_dataset(mean_file)
    
    for item in mlo:
        lo=50#mlo[idt]
        la=90#mla[idt]
        
        xh=np.squeeze(dsem.sst[:,:,:].data)
        print(xh.shape)
        stm=stm+xh
        stdm=stdm+(xh*xh)
        print('ensemble %s' %ifens)
        #dm["meanE{0}".format(inm)]=stm
        #ds["stdE{0}".format(inm)]=stdm
        ifens=ifens+1
    time[:]=dsem.time_centered[:].data
    lons[:,:]=dsem.nav_lon.data
    lats[:,:]=dsem.nav_lat.data
    dsem=None
        #xh=xh[292*5:]
        #time2e=dsem.time_centered[292*5:]
        #colorgr=(np.random.random(3))
        #axes4.plot(time2e,xh,color=colorgr,label='5 Days',linewidth=0.3)
        #ifens=ifens+1
        #dsem=None
        
meansst[:,:,:]=stm/50
stdsst[:,:,:] =stdm/50
stdsst2[:,:,:] =(stdm/50)-((stm/50)*(stm/50))
meanS.close()
