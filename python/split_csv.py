# -*- coding: utf-8 -*-
"""
Created on Thu Mar  4 20:31:55 2021

@author: Kovid
"""

import pandas as pd
from time import time
import os.path
 
def fill_null(fname, mon):
    # columns to sanitise
    colmuns_tbd = ["trip_distance", "pickup_longitude", "pickup_latitude", "dropoff_longitude", "dropoff_latitude"]
    data = pd.read_csv(f'D:/{fname}/{fname}_{mon}.csv', low_memory=False)
    # fill empty cells with 0
    data[colmuns_tbd] = data[colmuns_tbd].replace(r'\s+', 0, regex=True)
    data = data.replace(r'\s+', 0, regex=True)
    data.to_csv(f'D:/{fname}_{mon}.csv', index=False)
    
def fill_null_split(fname, mon):
    if 'data' in fname: # clean long, lat columns
        fill_null(fname, mon)
    # split file
    csvfile = open(f'D:/{fname}_{mon}.csv', 'r').readlines()
    fileno = 1
    # To evenly divide the csv into 3/4 files
    limit = 3497545 if 'data' in fname else 4663393
    for i in range(len(csvfile)):
          if i % limit == 0:
              open(f'D:/{fname}_{mon}_{str(fileno)}.csv', 'w+').writelines(csvfile[i:i+limit])
              fileno += 1
              exit()

if __name__ == "__main__":
    start_main = time()
    fname = 'data'
    mon = '2' # 2=February
    if not os.path.isfile(f'D:/trip_{fname}_{mon}_1.csv'):
        fill_null_split(f'trip_{fname}', mon) 
