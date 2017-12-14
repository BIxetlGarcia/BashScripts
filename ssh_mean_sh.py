
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

path='/ccc/scratch/cont003/gen0727/garciagi/'
#mfiles=  'GOM025-GSL301.050_y1993-2012.1d_gridT.nc','GOM025-GSL301.001_y1993-2012.1d_gridT.nc'
#filenames=sorted(glob.glob('/home/users/garcia8ix/workd/ENTROPY/5-days-avg/*.nc'))
#print(len(filenames))
#meanfile='/home/users/garcia8ix/workd/ENTROPY/stats/Smean.nc'


# In[3]:
mfiles=sorted(glob.glob('/ccc/scratch/cont003/gen0727/garciagi/FILTER/GOM025.GSL301_m*_H_filt.nc'))
trfiles=sorted(glob.glob('/ccc/scratch/cont003/gen0727/garciagi/outtrends/test/splinesH*'))

#mfiles=mfiles[0:25]
#dsh = xr.open_mfdataset(mfiles,concat_dim='ensemble')


# In[4]:

dsl=xr.open_dataset('/ccc/scratch/cont003/gen0727/garciagi/1d/NATL025.GSL301_m024.1d_gridT.nc')
#mds=xr.open_dataset(meanfile)

lats=dsl.nav_lat
lons=dsl.nav_lon
time2=dsl.time_centered
time3 = pd.date_range('1993-01-01','2012-12-26' , freq='5D')

ifens=0
ntime=len(time2[:])
nrow=lats.shape[0]
ncols=lats.shape[1]            
print(len(mfiles))              
meanS= NetCDFFile('/ccc/scratch/cont003/gen0727/garciagi/SSHmeanLF.nc', 'w', format='NETCDF3_64BIT')

meanS.createDimension('time_counter', ntime)
meanS.createDimension('y', nrow)
meanS.createDimension('x', ncols)   
meanS.createDimension('member',len(mfiles))

time = meanS.createVariable('time', 'f4', ('time_counter',))
lats  = meanS.createVariable('lons','f4',('y','x'))
lons  = meanS.createVariable('lats','f4',('y','x'))
 
meanssh  = meanS.createVariable('meanssh', 'f4', ('time_counter', 'y','x'))
varssh  = meanS.createVariable('varssh', 'f4', ('time_counter', 'y','x'))
varssh2  = meanS.createVariable('varssh2', 'f4', ('time_counter', 'y','x'))
varsshi  = meanS.createVariable('varsshi', 'f4', ('member', 'y','x'))
filread  = meanS.createVariable('filread', 'f4', ('member'))

mlo=[1] 
stm=np.zeros((len(time2[:]),lats.shape[0],lats.shape[1]))
stdm=np.zeros((len(time2[:]),lats.shape[0],lats.shape[1]))
sti=np.zeros((len(mfiles),lats.shape[0],lats.shape[1]))
fils=np.zeros(len(mfiles))
for item in mfiles:
    
    mean_file=mfiles[ifens]
    print(mean_file)
    #lines=np.load(trfiles[ifens])
    dsem = xr.open_dataset(mean_file)
    
    for item in mlo:
        lo=50#mlo[idt]
        la=90#mla[idt]
        
        xh=dsem.ssht[:,:,:]
        print(xh.shape)
        stm=stm+xh
        stdm=stdm+(xh*xh)
        sti[ifens,:,:]=np.var(xh,axis=0)
        print('ensemble %s' %ifens)
        #dm["meanE{0}".format(inm)]=stm
        #ds["stdE{0}".format(inm)]=stdm
        fils[ifens]=ifens
        ifens=ifens+1
    dsem=None


time[:]=dsl.time_centered[:].data
lons[:,:]=dsl.nav_lon.data
lats[:,:]=dsl.nav_lat.data
meanssh[:,:,:]=stm.data/50.
varssh[:,:,:] =stdm.data/50.
varssh2[:,:,:] =(stdm.data/50.)-((stm.data/50.)*(stm.data/50.))
varsshi[:,:,:]=sti
filread[:]=fils
meanS.close()
