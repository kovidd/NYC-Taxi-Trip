# -*- coding: utf-8 -*-
"""
Created on Tue Mar  9 17:12:48 2021

@author: Dragon
"""

import pandas as pd

lst = ['Geeks', 'For', 'Geeks', 'is',  
            'portal', 'for', 'Geeks'] 

lst = [0,1,2,3,4,5,6,7,8]
# Calling DataFrame constructor on list 
df = pd.DataFrame(lst, columns =['num']) 
print(df)

df = df[df['num'] > 1]
df = df[df['num'] < 7]
print(df)