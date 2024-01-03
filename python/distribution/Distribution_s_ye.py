#!/usr/bin/python

# Data Shaping
# This code is used to shape the data

import sys # system call
import numpy as np
import math
import matplotlib.pyplot as plt
from matplotlib import ticker
import matplotlib.cm as cm
import re

import matplotlib.colors as colors

#################################
# open files
#################################

inputfile="sppdata/sppSc.00475"
 
try:
    input =inputfile
    print(input)
    finp  = open(input, 'r')
    print("Reading " + input)
    data = np.loadtxt(input,comments='#')
    print("... done")
    finp.close()
except IOError:
    print('"%s" cannot be opened.' % input)
    sys.exit()


columns = [data[:, n] for n in range(22)]
radius, theta, phi, volume, rho, Ye, T, s, P, vr,vt,vp, yed,ed,ebind,shock, Lnue,Enue, Lnub, Enub, LnuX, EnuX = columns
Msolar=1.9891e33
s_eject =np.empty(0)
Ye_eject=np.empty(0)
dM_eject=np.empty(0)
for n in range(radius.size):
    if shock[n] >  0.0 and ebind[n] >=  0.0 :
        s_eject = np.append(s_eject,s[n])
        Ye_eject = np.append(Ye_eject,Ye[n])
        dM_eject = np.append(dM_eject,volume[n]*rho[n]/Msolar)
        
print(s_eject.size)

####################
# histgram
####################
otputfile="./hist_s-ye00475.png"

fig=plt.figure()


# Name and size of font
fnameforfig="sans-serif"
fsizeforfig=18

totx=1
toty=1

index=1
ax = fig.add_subplot(totx,toty,index)

xbins=100
ybins=100
#ax.set_aspect('equal')
counts, xgrids, ygrids, image = ax.hist2d(Ye_eject,s_eject, bins=[xbins,ybins], weights=dM_eject)

ax.set_xlabel(r'$Y_e$', fontsize=fsizeforfig, fontname=fnameforfig)
ax.set_ylabel(r'$s$'  , fontsize=fsizeforfig, fontname=fnameforfig)

fig.savefig(otputfile)


####################
# distribution
####################

otputfile="./dist_s-ye00475.png"
fig=plt.figure()

totx=1
toty=1

index=1
ax = fig.add_subplot(totx,toty,index)

vmindm=-7.0
vmaxdm=-3.0
lev_exp = np.arange(vmindm,vmaxdm+1.0)
levs = np.power(10, lev_exp)

#cs=ax.contourf(Ye_eject,s_eject,counts, levels=levs, extent=[xgrids.min(), xgrids.max(), ygrids.min(), ygrids.max()],locator=ticker.LogLocator(),vmin=1.0e-7, cmap = cm.rainbow)
x,y = np.meshgrid(xgrids,ygrids)
cs=ax.pcolor(x,y,counts,norm=colors.LogNorm(vmin=1.0e-7, vmax=1.0e-3), cmap = cm.jet)

cs.set_clim(vmin=levs.min(), vmax=levs.max())
cs.cmap.set_under('white')
cs.changed()

ax.set_xlabel(r'$Y_e$', fontsize=fsizeforfig, fontname=fnameforfig)
ax.set_ylabel(r'$s$'  , fontsize=fsizeforfig, fontname=fnameforfig)

#pc = ax.pcolor(cs)
fig.colorbar(cs)
fig.savefig(otputfile)
