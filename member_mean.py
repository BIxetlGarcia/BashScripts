
# coding: utf-8

# In[1]:

import os
import numpy as np
import pandas as pd
import xarray as xr
import glob
import matplotlib.pyplot as plt
from scipy.io import netcdf
from scipy import signal
from netCDF4 import num2date
from netCDF4 import Dataset as NetCDFFile 
import matplotlib.dates as mdates
#from mpl_toolkits.basemap import Basemap
import datetime


# In[2]:

path='/ccc/scratch/cont003/gen0727/garciagi/'
mfiles=sorted(glob.glob('/ccc/scratch/cont003/gen0727/garciagi/SECTIONS/FS/NATL025-GSL301*FS.5d_section.nc'))


# In[4]:

dsl=xr.open_dataset(mfiles[0])

lats=dsl.nav_lat
lons=dsl.nav_lon
time2=dsl.time_counter
time3 = pd.date_range('1993-01-01','2012-12-26' , freq='5D')
depths=dsl.deptht
print(depths.shape)
#ifens=0
ntime=len(time2[:])
nrow=lats.shape[0]
ncols=lats.shape[1]
ndepths=len(depths[:])            
print(len(mfiles),ntime,nrow,ncols,ndepths)              
meanF= NetCDFFile('/ccc/scratch/cont003/gen0727/garciagi/mean_trp_FS.nc', 'w', format='NETCDF3_64BIT')

meanF.createDimension('time_counter', ntime)
meanF.createDimension('z', ndepths)
meanF.createDimension('y', nrow)
meanF.createDimension('x', ncols)   
meanF.createDimension('member',len(mfiles))

time = meanF.createVariable('time', 'f4', ('time_counter',))
lats  = meanF.createVariable('lons','f4',('y','x'))
lons  = meanF.createVariable('lats','f4',('y','x'))
depth =meanF.createVariable('depth','f4',('z'))

meanT  = meanF.createVariable('meanTrp', 'f4', ('time_counter'))#' ('time_counter','z', 'y','x'
varT  = meanF.createVariable('varTrp', 'f4', ('time_counter' ))# ('time_counter','z', 'y','x')
varT2  = meanF.createVariable('varTrp2', 'f4', ('time_counter'))#('time_counter','z', 'y','x')
varTi  = meanF.createVariable('varTrpi', 'f4', ('member'))#('member','z', 'y','x')

meanS  = meanF.createVariable('meanMxl', 'f4', ('time_counter', 'y','x'))#('time_counter','z', 'y','x')
varS  = meanF.createVariable('varMxl', 'f4', ('time_counter', 'y','x'))#('time_counter','z', 'y','x')
varS2  = meanF.createVariable('varMxl2', 'f4', ('time_counter', 'y','x'))#
varSi  = meanF.createVariable('varMxli', 'f4', ('member', 'y','x'))#('member','z', 'y','x')

meanV  = meanF.createVariable('meanSSH', 'f4', ('time_counter', 'y','x'))
varV  = meanF.createVariable('varSSH', 'f4', ('time_counter', 'y','x'))
varV2  = meanF.createVariable('varSSH2', 'f4', ('time_counter', 'y','x'))
varVi  = meanF.createVariable('varSSHi', 'f4', ('member', 'y','x'))


filread  = meanF.createVariable('filread', 'f4', ('member'))


nt,nz,ny,nx=dsl.votemper.shape
mlo=[1] 
stm=np.zeros((nt))
#stm=np.zeros((nt,nz,ny,nx))
stdm=np.zeros((nt))#stdm=np.zeros((nt,nz,ny,nx))
sti=np.zeros((len(mfiles)))#np.zeros((len(mfiles),nz,ny,nx))

ssm=np.zeros((nt,ny,nx))
ssdm=np.zeros((nt,ny,nx))
ssi=np.zeros((len(mfiles),ny,nx))

svm=np.zeros((nt,ny,nx))
svdm=np.zeros((nt,ny,nx))
svi=np.zeros((len(mfiles),ny,nx))

fils=np.zeros(len(mfiles))
ifens=0
for item in mfiles:
    
    mean_file=mfiles[ifens]
    print(mean_file)
    #lines=np.load(trfiles[ifens])
    dsem = xr.open_dataset(mean_file)
    
    for item in mlo:
        lo=50#mlo[idt]
        la=90#mla[idt]
        
        xh=dsem.barotrop_FS
        print(xh.shape)
        stm=stm+xh
        stdm=stdm+(xh*xh)
        sti[ifens]=np.var(xh,axis=0)

        xs=dsem.somxl010
        print(xs.shape)
        ssm=ssm+xs
        ssdm=ssdm+(xs*xs)
        ssi[ifens,:,:]=np.var(xs,axis=0)

        xv=dsem.sossheig
        print(xv.shape)
        svm=svm+xv
        svdm=svdm+(xv*xv)
        svi[ifens,:,:]=np.var(xv,axis=0)

        print('ensemble %s' %ifens)
        #dm["meanE{0}".format(inm)]=stm
        #ds["stdE{0}".format(inm)]=stdm
        fils[ifens]=ifens
        ifens=ifens+1
    dsem=None


time[:]=dsl.time_counter[:].data
lons[:,:]=dsl.nav_lon.data
lats[:,:]=dsl.nav_lat.data
depth[:]=dsl.deptht.data

meanT[:]=stm.data/50.
varT[:] =stdm.data/50.
varT2[:] =(stdm.data/50.)-((stm.data/50.)*(stm.data/50.))
varTi[:]=sti

meanS[:,:,:]=ssm.data/50.
varS[:,:,:] =ssdm.data/50.
varS2[:,:,:] =(ssdm.data/50.)-((ssm.data/50.)*(ssm.data/50.))
varSi[:,:,:]=ssi

meanV[:,:,:]=svm.data/50.
varV[:,:,:] =svdm.data/50.
varV2[:,:,:] =(svdm.data/50.)-((svm.data/50.)*(svm.data/50.))
varVi[:,:,:]=svi

filread[:]=fils
meanF.close()
