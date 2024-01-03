#!/usr/bin/python

# Data Shaping
# This code is used to shape the data

import sys # system call
import numpy as np
import math
import matplotlib.pyplot as plt
import re

#################################
# open files
#################################

inputfile="sppdata/sppSc.00475"
otputfile="./s-ye00475.png"
 
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

s_eject =np.empty(0)
Ye_eject=np.empty(0)
for n in range(radius.size):
    if ebind[n] >=  0.0:
        s_eject = np.append(s_eject,s[n])
        Ye_eject = np.append(Ye_eject,Ye[n])
print(s_eject.size)

s_shock =np.empty(0)
Ye_shock=np.empty(0)
for n in range(radius.size):
    if shock[n] >  0.0 and ebind[n] >=  0.0 :
        s_shock = np.append(s_shock,s[n])
        Ye_shock = np.append(Ye_shock,Ye[n])
print(s_shock.size)

totx=1
toty=1

fig=plt.figure()


# Name and size of font
fnameforfig="sans-serif"
fsizeforfig=18

index=1
ax = fig.add_subplot(totx,toty,index)
im =ax.scatter(Ye_eject,s_eject)
ax.set_xlabel(r'$Y_e$', fontsize=fsizeforfig, fontname=fnameforfig)
ax.set_ylabel(r'$s$'  , fontsize=fsizeforfig, fontname=fnameforfig)

fig.savefig(otputfile)
