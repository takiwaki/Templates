#!/usr/bin/python

import sys # system call
import numpy as np
import math
import matplotlib.pyplot as plt
from matplotlib import ticker
import matplotlib.cm as cm
import re

import matplotlib.colors as colors

from scipy.interpolate import griddata
import random
from random import randint, randrange

#################################
# open files
#################################

xinp=np.empty(0)
yinp=np.empty(0)
zinp=np.empty(0)

for n in range(1000):
    xtmp = randrange(1.0, 10.0)
    ytmp = 10**(randrange(1.0, 10.0))
    ztmp = int((xtmp-5.0)*(np.log10(ytmp)-5.0))

    xinp = np.append(xinp,xtmp)
    yinp = np.append(yinp,ytmp)
    zinp = np.append(zinp,ztmp)

####################
# Linear
####################
otputfile="./testLin.png"

fig=plt.figure()


# Name and size of font
fnameforfig="sans-serif"
fsizeforfig=18

totx=1
toty=1

index=1
ax = fig.add_subplot(totx,toty,index)

x_min, x_max = xinp.min(), xinp.max()
y_min, y_max = yinp.min(), yinp.max()

new_x_coord = np.linspace(x_min, x_max, 100)
new_y_coord = np.linspace(y_min, y_max, 300)

xx, yy = np.meshgrid(new_x_coord, new_y_coord)

knew_xy_coord = xinp, yinp
knew_values   = zinp

result = griddata(points=knew_xy_coord, values=knew_values, xi=(xx, yy), method='nearest')

cs=ax.contourf(xx,yy,result)
ax.set_xlabel(r'$x$', fontsize=fsizeforfig, fontname=fnameforfig)
ax.set_ylabel(r'$y$', fontsize=fsizeforfig, fontname=fnameforfig)

fig.colorbar(cs)
fig.savefig(otputfile)

####################
# Log
####################

otputfile="./testLog.png"

totx=1
toty=1

index=1
fig=plt.figure()
ax = fig.add_subplot(totx,toty,index)

new_x_coord = np.linspace(x_min, x_max, 100)
new_y_coord = np.linspace(np.log10(y_min), np.log10(y_max), 100)

xx, yy = np.meshgrid(new_x_coord, new_y_coord)

knew_xy_coord = xinp, np.log10(yinp)
knew_values   = zinp

result = griddata(points=knew_xy_coord, values=knew_values, xi=(xx, yy), method='nearest')

cs=ax.contourf(xx,10**(yy),result)
ax.set_xlabel(r'$x$', fontsize=fsizeforfig, fontname=fnameforfig)
ax.set_ylabel(r'$y$', fontsize=fsizeforfig, fontname=fnameforfig)

fig.colorbar(cs)

ax.set_yscale('log')
fig.savefig(otputfile)

