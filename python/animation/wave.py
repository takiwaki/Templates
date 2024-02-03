import numpy as np
import math

kx=1.0
omega=1.0
amp=1.0
outputdir="images"

def main():
    global outputdir
    import os
    print("start")
    os.makedirs(outputdir, exist_ok=True)
    x = SetUpCoordinate()
    t = 0.0
    dt = 0.01
    Nt = 100
    for n in range(0,Nt):
        y=SinWave(t,x)
        outputfile=outputdir+"/wav{:<5s}.png".format(str(n).zfill(5))
        Plotwave(t,x,y,outputfile)
        t = t + dt
    print("stop")

def SetUpCoordinate():
    Nx = 100
    xmin=-1.0
    xmax=1.0
    x = np.linspace(xmin, xmax, Nx) 
    return x
    
def SinWave(t,x):
    global kx, omega,amp
    y = amp*np.sin(math.pi*(kx*x-omega*t))
    return y

#######################################
# just a preparation for the matplot lib
#######################################
import matplotlib.pyplot as plt
from cycler import cycler
fnameforfig="sans-serif"
fsizeforfig=12
fsizeforlabel=14
plt.rcParams['font.family'] = fnameforfig
plt.rcParams['font.size'] = fsizeforfig
plt.rcParams['xtick.direction'] = 'in'
plt.rcParams['ytick.direction'] = 'in'
plt.rcParams["xtick.minor.visible"] = True
plt.rcParams["ytick.minor.visible"] = True
plt.rcParams['xtick.top'] = True
plt.rcParams['ytick.right'] = True
# red, blue, green, yellow, sky-blue azure, pink, orange, purple, brown
cmapudc =  cycler(color=["#ff2800","#0041ff" ,"#35a16B","#faf500","#66ccff", "#ff99a0","#ff9900" ,"#9a0079", "#663300"])
plt.rcParams['axes.prop_cycle'] = cmapudc
cmap = ["#ff2800","#0041ff" ,"#35a16B","#faf500","#66ccff", "#ff99a0","#ff9900" ,"#9a0079", "#663300"]

def Plotwave(t,x,y,outputfile):
    global amp
    fig = plt.figure()
    ax  = fig.add_subplot(1,1,1)
    im  = ax.plot(x,y, label="sin wave")
    ax.set_xlim(x.min(),x.max())
    ax.set_ylim(-amp,amp)
    ax.set_xlabel(r"$x$")
    ax.set_ylabel(r"$y$")
    ax.legend()
    fig.tight_layout()
    print("damp "+outputfile)
    fig.savefig(outputfile)
    plt.close()

#######################################
# Excute Main (Do not delete!)
#######################################
if __name__ == "__main__":
  main()
