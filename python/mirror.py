#
# This script creates equatorially symmetric global data from data in the northern hemisphere.
#
import math
import numpy as np

inputfile="data2D.data"
outputfile="data2Dsym.data"
colnum=10

def ReadData(file):
    # Read the data of northen hemisphere
    print("Reading "+file)
    try:
        with open(file, 'r') as f:
            lines = f.readlines()
            resolution = lines[1].strip().split()
            nr, nt = int(resolution[1]), int(resolution[2])
    except IOError:
        print(" cannot open " + file )
        sys.exit()
    header = lines[0:7]
    print(header)
    data = np.genfromtxt(file,skip_header=7)
    split_arrays = np.split(data,colnum,1)
    reshaped_arrays = [arr.reshape((nt, nr)) for arr in split_arrays]
    rad, th, den, pre, tempK, ent, css, omega, bphi, Aphi = reshaped_arrays
    datapackNor = (rad, th, den, pre, tempK, ent,css,omega,bphi,Aphi)
    print ("nor",rad.shape[0],rad.shape[1])
    #print ("nor",rad[0,1])
    
    return  datapackNor, header

def Symmetrize(datapackNor):
    # Create the global

    # Create the data of southern hemisphere 
    datapackINV  = [ arr[::-1,:].copy() for arr in datapackNor ]
    # Delete the data on the eqatorial plane
    datapackINVM = [ arr[1:,:] for arr in datapackINV ]
    # theta_new = pi - theta_original
    datapackINVM[1] = math.pi - datapackINVM[1]

    
    datapackAll = [
        np.vstack((datapackNor[i], datapackINVM[i]))
        for i in range(colnum)
    ]
 
    
    #datapackAll = (rad, th, den, pre, tmpe, ent,css,omega,bphi,Aphi)
    #datapackAll = datapackNor
    rad, th, den, pre, tmpe, ent,css,omega,bphi,Aphi =  datapackAll
    print ("all",rad.shape[0],rad.shape[1])
    #print ("all",rad[0,1])
    return  datapackAll


def Main():
    global inputfile,outputfile
    datapackNor, header  = ReadData(inputfile)
    datapackAll = Symmetrize(datapackNor)
    OutputData(datapackAll,outputfile,header)

def OutputData(datapack,ofile,header_lines):
    
    rad, th, den, pre, tmpe, ent,css,omega,bphi,Aphi =  datapack
    nt = rad.shape[0]
    nr = rad.shape[1]
    
    items = header_lines[1].strip().split()
    items[2] = str(nt)
    header_lines[1] = " ".join(items)+"\n"
    header_str = "".join(header_lines)
    #flat_arrays = [var.flatten() for var in datapack]
    #combined = np.column_stack(flat_arrays)
    #np.savetxt(ofile, combined, header=header_str, comments='')
    
    print("Writing "+ofile)
    with open(ofile, 'w') as f:
        f.write(header_str)
    
        for j in range(nt):
            for i in range(nr):
                values = [ arr[j,i] for arr in datapack]
                line = " ".join(f"{val:.12e}" for val in values)
                f.write(line+"\n")
            f.write('\n')

    
Main()
