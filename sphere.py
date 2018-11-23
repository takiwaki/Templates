#!/usr/bin/python

import sys # system call
import numpy as np
import matplotlib.pyplot as plt

#################################
# open files
#################################
try:
    input = "dytSc.191"
    print(input)
    finp  = open(input, 'r')
    print("Reading " + input)
    dinp  = finp.read()
    print("... done")
    finp.close()
except IOError:
    print('"%s" cannot be opened.' % input)
    sys.exit()


line  = dinp.split("\n")
items = line[0].split()
numr = int(items[0])
numt = int(items[1])
nump = int(items[2])

print("resolution",numr,"x",numt,"x",nump)

rad = np.zeros(numr)
the = np.zeros(numt)
phi = np.zeros(nump)

rho = np.zeros(numr*numt*nump).reshape(numr,numt,nump)
ye  = np.zeros(numr*numt*nump).reshape(numr,numt,nump)
tem = np.zeros(numr*numt*nump).reshape(numr,numt,nump)
vr  = np.zeros(numr*numt*nump).reshape(numr,numt,nump)

for k in range(nump):
    for j in range(numt):
        for i in range(numr):
            index = (i+1) + numr*j +numr*numt*k 
            items = line[index].split()
            rad[i] = items[0]
            the[j] = items[1]
            phi[k] = items[2]
            rho[i,j,k] = items[3]
            ye [i,j,k] = items[4]
            tem[i,j,k] = items[5]
            vr [i,j,k] = items[6]

ir1=50
ir2=45
vrnorm=1e7
title1=r"$\delta v_r\ [10^7 cm/s]$ at "+str(rad[ir1]/1.0e5)+" km"
title2=r"$\delta Y_e$ at "+str(rad[ir2]/1.0e5)+" km"

vrs  = np.zeros(numt*nump).reshape(numt,nump)
yes  = np.zeros(numt*nump).reshape(numt,nump)

vrave=0.0
yeave=0.0
for k in range(nump):
    for j in range(numt):
        vrave      =  vrave + vr[ir1,j,k]
        yeave      =  yeave + ye[ir2,j,k]

vrave=vrave/nump/numt
yeave=yeave/nump/numt

for k in range(nump):
    for j in range(numt):
        vrs[j,k] =  (vr[ir1,j,k]-vrave)/vrnorm
        yes[j,k] =  ye[ir2,j,k]-yeave

X,Y = np.meshgrid(phi,the)
Z1 = vrs
Z2 = yes

# Make figure
myfig1 = plt.figure()
myfig2 = plt.figure()

myax1  = myfig1.add_subplot(1,1,1)
myax2  = myfig2.add_subplot(1,1,1)

fnameforfig="sans-serif"
fsizeforfig=18

myax1.set_title(title1, fontsize=fsizeforfig, fontname=fnameforfig)
myax2.set_title(title2, fontsize=fsizeforfig, fontname=fnameforfig)

myax1.set_xlabel(r'$\phi$', fontsize=fsizeforfig, fontname=fnameforfig)
myax2.set_xlabel(r'$\phi$', fontsize=fsizeforfig, fontname=fnameforfig)

myax1.set_ylabel(r'$\theta$', fontsize=fsizeforfig, fontname=fnameforfig)
myax2.set_ylabel(r'$\theta$', fontsize=fsizeforfig, fontname=fnameforfig)

# Contour
#myim1 = myax1.contourf(X,Y,Z1,cmap='bwr',interpolation='spline16')
#myim2 = myax2.contourf(X,Y,Z2,cmap='bwr',interpolation='spline16')
#

# Pseudo Colro
myim1  = myax1.pcolor(X,Y,Z1,cmap="bwr")
myim2  = myax2.pcolor(X,Y,Z2,cmap="Spectral")

myim1.set_clim(-0.5e8/vrnorm,0.5e8/vrnorm)
myim2.set_clim(-0.015,0.015)

# Color bar
myfig1.colorbar(myim1)
myfig2.colorbar(myim2)

myfig1.savefig('vrsphere.png')
myfig2.savefig('yesphere.png')
