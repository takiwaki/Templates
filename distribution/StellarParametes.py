#!/usr/bin/python

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


Msun   = 1.989e33

dir_path = "S16progenitor_models/"
modelindex ="S16"
otputtable='./S16summary.csv'
otputfile="Mco-xi.png"

def Main():
    global modelindex
    FileList = GetFileList()
    dfout = pd.DataFrame([], columns=['Ref','ZAMS_mass','Mco','xi_1.5','xi_1.75','xi_2.0','xi_2.5'])

    for File in FileList:
        print("Reading " + File)
        df = ReadData(File)
        xi = GetCompactness(df)
        Mco = GetCOcore(df)
        Model = File.replace("_presn","")
        Model = Model.replace("s","")
        Mzams = float(Model)
#        print(Mco)
        addRow = pd.DataFrame([modelindex, Mzams, Mco, xi[0], xi[1], xi[2], xi[3]],index=dfout.columns).T
        dfout  = dfout.append(addRow)

    dfout.to_csv(otputtable,index=False)

    ScatterMco_xi(dfout)

def GetFileList():
    global dir_path
    files = os.listdir(dir_path)
#    print(files)
#    print(type(files))
    return files

def ReadData(file):
    path = dir_path + file
    df = pd.read_csv(path,sep='\s+',skiprows=2,header=None)
    return df

def GetCompactness(df):
    mass   = df[1]
    radius = df[2]
#    print(radius)
    global Msun
    Rscale = 1.0e8
    nmax = 4
    Mth = np.zeros(nmax)
    xi  = np.zeros(nmax)
    Mth[0] = 1.5
    Mth[1] = 1.75
    Mth[2] = 2.0
    Mth[3] = 2.5
    for i in range(mass.size):
#        print(mass[i],radius[i])
        for n in range(nmax):
            if mass[i]/Msun > Mth[n] and xi[n] == 0.0:
                xi[n]= (mass[i]/Msun)/(radius[i]/Rscale)
    return xi


def GetCOcore(df):
    global Msun
    mass   = df[1]
    radius = df[2]
    He     = df[17]
    Thread = 0.1e0
#    print(He)
    Mco = 0.0e0
#    quit()

    for i in range(mass.size):
        if He[i] > Thread  and Mco == 0.0e0 and  mass[i]  > 1.5*Msun:
            Mco =mass[i]/Msun
    return Mco


def ScatterMco_xi(df):
    global Name


    # otputfile and size of font
    fnameforfig="sans-serif"
    fsizeforfig=18
    fig=plt.figure()

    ax = fig.add_subplot(2,1,1)

    x = df["ZAMS_mass"]
    y = df['xi_2.5']

    im =ax.scatter(x,y)
    ax.set_xlabel(r'$M_{\rm ZAMS}$', fontsize=fsizeforfig, fontname=fnameforfig)
    ax.set_ylabel(r'$\xi_{2.5}$'  , fontsize=fsizeforfig, fontname=fnameforfig)

    ax = fig.add_subplot(2,1,2)

    x = df["Mco"]
    y = df['xi_2.5']

    im =ax.scatter(x,y)
    ax.set_xlabel(r'$M_{\rm CO}$', fontsize=fsizeforfig, fontname=fnameforfig)
    ax.set_ylabel(r'$\xi_{2.5}$'  , fontsize=fsizeforfig, fontname=fnameforfig)

    fig.savefig(otputfile)

Main()
