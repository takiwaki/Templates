#!/usr/bin/env python

#################################
# preparation
#################################
import sys # system call

#################################
# open files
#################################
try:
    input1 ="./Explosion-t-prof1D.dat"
    finp = open(input1, 'r')
except IOError:
    print '"%s" cannot be opened.' % input1
    sys.exit()
print "Processing " + input1

#################################
# Data Read
#################################
timesim=[]
timepb =[]
rshock =[]
rgain  =[]
Mdot   =[]
ln=0 # number of the line
for line in finp:
    ln = ln+1
#    print ln
# the number of line that you want to skip first.
    if ln <= 1:
        continue
    data =line.split()
    timesim += [float(data[ 0])] # [s]
    timepb  += [float(data[ 1])] # [s]
    rshock  += [float(data[ 2])] # [cm]
    rgain   += [float(data[ 5])] # [cm]
    Mdot    += [float(data[14])] # [M_s/s]
finp.close()
print "data num:",ln
data_max=ln-2
print(timesim[0])
print(timesim[1])

quit
olist= [""]
for ln in range(1,data_max):
    print ln
    olineExp = " %07e %07e %07e %07e %07e " \
    % (timesim[ln], timepb[ln], rshock[ln], rgain[ln], Mdot[ln]) 

    oline = olineExp+"\n"
    olist.append(oline)

#################################
#  output file
#################################
output = "t-prof_sum1D.dat"
foup = open(output, 'w')
foup.writelines(olist)
foup.close()
