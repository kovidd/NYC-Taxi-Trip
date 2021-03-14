# -*- coding: utf-8 -*-
"""
Created on Sat Mar  6 23:41:56 2021

@author: Dragon
"""

from matplotlib.pyplot import figure
import matplotlib as mpl
import pandas as pd

# To plot all points
mpl.rcParams['agg.path.chunksize'] = 10000

# To display all rows-cols when using pandas
pd.set_option("display.max_rows", None, "display.max_columns", None)
pd.set_option('float_format', '{:.4f}'.format)  # Scientific notation to float
