# -*- coding: utf-8 -*-
"""
Created on Sat Mar  6 23:38:43 2021

@author: Kovid
"""

import numpy as np
import pandas as pd
import psycopg2 as pg2
from time import time


def make_pickle(fname):
    start = time()
    # conn = pg2.connect(database='<dbname>', user='postgres', password='<pwd>', port=5432)
    # cur = conn.cursor()
    # df = pd.read_sql_query('SELECT * FROM distance_time;', conn)
    
    df = pd.read_csv(f'D:/{fname}_analysis.csv', low_memory=False)
    # change dtype of pickup_datetime to datetime
    if 'pickup_datetime' in df.columns:
        df['pickup_datetime'] = pd.to_datetime(df['pickup_datetime'], format='%Y-%m-%d %H:%M:%S')
    if 'dropoff_datetime' in df.columns:
        df['dropoff_datetime'] = pd.to_datetime(df['dropoff_datetime'], format='%Y-%m-%d %H:%M:%S')
    df.to_pickle(f'D:/pandas/cached_df_{fname}.pkl')  # store in directory
    print("\nTime to make dataframe:", "{:.2f}".format((time()-start)/60), "mins")
    return df


def read_pickle(fname):
    try:    
        df = pd.read_pickle(f'D:/pandas/cached_df_{fname}.pkl')  # read from directory
        print("\nPickle file found, won\'t reset the pickle!")
    except Exception:
        print("\nPickle not found, please wait!")
        df = make_pickle(fname)
    return df
