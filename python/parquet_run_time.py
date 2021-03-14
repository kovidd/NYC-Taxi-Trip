# -*- coding: utf-8 -*-
"""
Created on Tue Mar  9 01:06:38 2021

@author: Kovid
"""

import set_options
import pandas as pd
from time import time

'''
    Time to read from paraquet: 0.24 mins
    Time to read from csv: 0.44 mins
    Time to read from pickle: 0.06 mins
    Run time: 0.75 mins
'''
    
if __name__ == "__main__":   
    start_main = time()
    start = time()
    fname = 'fare'
    source_file_path = f'D:/trip_{fname}_2.parquet'
    data_frame = pd.read_parquet(source_file_path, engine='fastparquet')
    # print(data_frame.head())
    print("Time to read from paraquet:", "{:.2f}".format((time()-start)/60), "mins")
    
    start = time()
    data_frame = pd.read_csv(f'D:/trip_{fname}/trip_{fname}_2.csv')
    # print(data_frame.head())
    print("Time to read from csv:", "{:.2f}".format((time()-start)/60), "mins")
    
    start = time()
    data_frame = pd.read_pickle(f'D:/pandas/cached_df_{fname}.pkl') # read from directory
    # print(data_frame.head())
    print("Time to read from pickle:", "{:.2f}".format((time()-start)/60), "mins")
    
    print("Run time:", "{:.2f}".format((time()-start_main)/60), "mins")
    