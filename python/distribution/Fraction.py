#!/usr/bin/python


import sys # system call
import numpy as np
import pandas as pd
import math
import matplotlib.pyplot as plt
from matplotlib import ticker
import matplotlib.cm as cm
import re

import matplotlib.colors as colors

#################################
# open files
#################################

inputfile="fraction.csv"
# the data format is as follows
#"model","AIC","Ibc","II","RSN","BH","GRB"
#"Sana MT1 CE1",0.011630121,0.387514464,0.360665583,0.019012465,0.210499334,0.010678033
#"Sana MT1 CE01",0.000467628,0.102274784,0.615594642,0.001131358,0.266774271,0.013757316
#"Sana MT1 CE10",0.007020693,0.421914822,0.323432766,0.020212544,0.216551525,0.010867649

try:
    input =inputfile
    print("Reading " + input)
    df = pd.read_csv(inputfile,delimiter=',',engine="python")
    print("... done")
except IOError:
    print('"%s" cannot be opened.' % input)
    sys.exit()

# Check data for debug
#print(df)
#print(df.columns)
#print(df['model'])
#print(df['BH'])
#print(df['II'].values)

otputfile="./fraction.png"

fig=plt.figure(figsize=(19, 8))

# Name and size of font
fnameforfig="sans-serif"
fsizeforfig=18


totx=1
toty=1
index=1

ax = fig.add_subplot(totx,toty,index)


colorlist= {"II":"#FF4B00","BH":"#005AFF","GRB":"#03AF7A","Ibc":"#4DC4FF","RSN":"#F6AA00","AIC":"#FFF100"}

for target in "AIC","GRB","RSN","BH","Ibc","II":
    ax.plot( df[target].values,-df.index.values, "-or", label=target,linewidth=2,markersize=8,color=colorlist[target])

plt.yticks(-df.index.values,df['model'].values )

ax.grid(which = "major", axis = "x", color = "gray", alpha = 0.8, linestyle = "-", linewidth = 2)
ax.grid(which = "minor", axis = "x", color = "gray", alpha = 0.8, linestyle = "--", linewidth = 1)
ax.legend(loc='lower center', bbox_to_anchor=(.5, 1.05), ncol=6, fontsize=fsizeforfig,frameon=False)
plt.xticks(fontsize =fsizeforfig)
plt.yticks(fontsize =fsizeforfig)
ax.set_xlim(1.0e-3, 1.0)

plt.gca().spines['top'].set_visible(False)
plt.gca().spines['bottom'].set_visible(False)
ax.set_xscale('log')
#ax.set_xlabel(r'$Y_e$', fontsize=fsizeforfig, fontname=fnameforfig)
#ax.set_ylabel(r'$s$'  , fontname=fnameforfig)

fig.savefig(otputfile)

