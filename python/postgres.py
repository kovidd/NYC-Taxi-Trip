# -*- coding: utf-8 -*-
"""
Created on Thu Mar  4 12:29:19 2021

@author: Kovid
"""

import psycopg2 as pg2
import pandas as pd

conn = pg2.connect(database='<db_name>', user='postgres', password='<pwd>', port=5432)
cur = conn.cursor()
df1 = pd.read_sql_query('SELECT * FROM trip_data_raw LIMIT 5;', conn)
df2 = pd.read_sql_query('SELECT * FROM trip_fare_raw LIMIT 5;', conn)
print(df1)
print(df2)

df3 = pd.read_sql_query('SELECT DISTINCT(vendor_id) FROM trip_fare_raw;', conn)
df4 = pd.read_sql_query('SELECT DISTINCT(payment_type)FROM trip_fare_raw ORDER BY payment_type;', conn)
print(df3)
print(df4)

# to display all columns and rows
pd.set_option("display.max_rows", None, "display.max_columns", None)
pd.set_option('float_format', '{:f}'.format)

month = 2  # Feburary

# To describe a csv doc
# data = pd.read_csv(f'D:/trip_fare/trip_fare_{month}.csv', low_memory=False, nrows=20)
# data.dropna(inplace = True)
# print(data.head(10))
# print('\nData Types:\n', data.dtypes)
# print('\nData Describe\n', data.describe())
# print('\nData total_amount Describe\n', data.total_amount.describe())
# print('\nData Null Values\n', data.isnull().any())
# pay_type = data.payment_type.unique()
# print(data.surcharge.unique())
# print(len(pay_type))

# data = pd.read_csv(f'D:/trip_data/trip_data_{month}.csv', low_memory=False, nrows=20)
# data = pd.read_csv(f'D:/trip_data/trip_data_{month}.csv', low_memory=False)
# data.dropna(inplace = True) 
# print(data.head(10))
# print('\nData Types:\n', data.dtypes)
# print('\nData Describe\n', data.describe())
# # print('\nData total_amount Describe\n', data.total_amount.describe())
# print('\nData Null Values\n', data.isnull().any())
