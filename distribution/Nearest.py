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

from scipy.interpolate import griddata

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
otputfile="./test.png"

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
#counts, xgrids, ygrids, image = ax.hist2d(Ye_eject,s_eject, bins=[xbins,ybins], weights=dM_eject)

x_min, x_max = Ye_eject.min(), Ye_eject.max()
y_min, y_max =  s_eject.min(),  s_eject.max()

new_x_coord = np.linspace(x_min, x_max, 100)
new_y_coord = np.linspace(y_min, y_max, 100)

xx, yy = np.meshgrid(new_x_coord, new_y_coord)

knew_xy_coord = Ye_eject, s_eject,
knew_values = dM_eject

result = griddata(points=knew_xy_coord, values=knew_values, xi=(xx, yy), method='nearest')

cs=ax.contourf(xx,yy,result)

ax.set_xlabel(r'$Y_e$', fontsize=fsizeforfig, fontname=fnameforfig)
ax.set_ylabel(r'$s$'  , fontsize=fsizeforfig, fontname=fnameforfig)

fig.savefig(otputfile)

