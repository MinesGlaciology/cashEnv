from numba import jit
from osgeo import gdal
import numpy as np
import pandas as pd
import os
from tqdm import tqdm

def waveformC(raster):
    # Define constants
    cumpowr=np.zeros((544,1) , dtype=np.float32)   # Signal length
    # Define spatial weighting 
    x = np.arange(-50,50,0.5, dtype=np.float32)
    y = np.arange(-50,50,0.5, dtype=np.float32)
    # Why is meshgrid not supported in numba?!?
    # X, Y = np.meshgrid(x,y)
    X = np.zeros((200,200), dtype=np.float32)
    Y = np.zeros((200,200), dtype=np.float32)
    for q in np.arange(200):
        X[q,:] = x
        Y[:,q] = y
    w=np.exp(-(X**2 + Y**2)/2/17.5**2)
    # Conversion to nanoseconds... 'D' is nanoseconds
    Z = raster[:,:] - np.max(raster[:,:])
    D = (np.abs(Z) / 0.15) + 10.0    # Start all recordings after 10 ns
    for i in np.arange(200):
        for j in np.arange(200):
            ibin=np.int(D[i,j]) #finding ibin
            #add power within pixel (i,j)-which is w(i,j) to the returned
            #power in the bin number ibin
            if ibin < 544:
                cumpowr[ibin]=cumpowr[ibin]+w[i,j]
    return cumpowr


wave_numba = jit(waveformC)


folder = "./output/"


idx = []
for i, filename in enumerate(os.listdir(folder)):
    fn, ext = os.path.splitext(filename)
    idx.append(fn)


space = np.zeros((len(idx),544),dtype=float)

for i, filename in enumerate(tqdm(os.listdir(folder))):
    source = gdal.Open(folder + filename)
    if (source.RasterYSize & source.RasterXSize) == 200:
        space[i,:] = wave_numba(source.ReadAsArray()).ravel()
    del(source)

April_20th_wf_no_conv = pd.DataFrame(space,index=idx,columns=np.arange(0,544,1))
store = pd.HDFStore('./April_wfs.h5','a')
store['raw'] = April_20th_wf_no_conv
store.close()

