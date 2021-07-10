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

inputfile="output/spec_hep.dat"
otputfile="output/spec_hep_new.dat"
 
tbnc=0.319535315773569 
G=6.67408e-8 # cm^3 g^-1 s^-2
cl=3.0e10 # cm s^-1
D=3.0e22
fac = 2.0/pow(math.pi,2)*G/pow(cl,3)/pow(D,2)


try:
    input =inputfile
    print(input)
    finp  = open(input, 'r')
    print("Reading " + input)
    lines  = finp.readlines()
    print("... done")
    finp.close()
except IOError:
    print('"%s" cannot be opened.' % input)
    sys.exit()

olist = [ "" ]
#                    12345678901234
oline = "#" + " " + "1:time_pb[s]  " \
            + " " + "2:freq[Hz]    " \
            + " " + "3:h_c@10kpc   " \
            + "\n"
olist.append(oline)

for line in lines:
#    print(line) # for debug
    flag=re.match("^\s*$",line)
#    print(flag) # for debug
    if flag :
        oline = "\n"
        olist.append(oline)
        continue
    items = line.split()
    time = float(items[0])
    freq = float(items[1])
    powr = float(items[2])
# debug
#    print ("time="+str(time))
#    print ("freq="+str(freq))
#    print ("powr="+str(powr))
    tmpb = time -tbnc
    hchr = pow(fac*powr,0.5)
    oline = "  {0:11.8e} {1:11.8e} {2:11.8e}\n".format(tmpb,freq,hchr)
#    print(oline) # debug
    olist.append(oline)


#################################
#  output file
#################################
foup = open(otputfile, 'w')
foup.writelines(olist) # normal order
#foup.writelines(reversed(olist)) # reverse order
foup.close()
