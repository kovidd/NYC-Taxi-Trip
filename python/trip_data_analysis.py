# -*- coding: utf-8 -*-
"""
Created on Sun Mar  7 01:16:40 2021

@author: Kovid
"""

import matplotlib.pyplot as plt
import set_options
import numpy as np
from time import time
from load_pickle import read_pickle


set_options.figure(num=None, figsize=(12, 8), dpi=300, facecolor='w', edgecolor='k')


def trips_per_hour(df):
    # df_hod = df.groupby(['hour_of_day'])['hour_of_day'].agg(['count'])
    hour_unique = list(df.hour_of_day.unique())
    hour_count = list(df.groupby(['hour_of_day'])['hour_of_day'].count())
    plt.bar(hour_unique, hour_count, label='Trips')    
    plt.xlabel("Hour")
    plt.xticks(hour_unique)
    plt.ylabel("Number of trips")
    plt.title('Trips per hour of day')
    plt.legend()
    plt.show()


def trip_duration(df):
    # df_hod = df.groupby(['hour_of_day'])['hour_of_day'].agg(['count'])
    df['trip_time_in_mins'] = (df['trip_time_in_secs']/60).astype(int)
    df = df[df['trip_time_in_mins'] < 90]  # only select time less than 90 mins
    mins_unique = list(df.trip_time_in_mins.unique())
    trip_count = list(df.groupby(['trip_time_in_mins'])['trip_time_in_mins'].count())
    # print(df.groupby(['trip_time_in_mins'])['trip_time_in_mins'].count())
    plt.bar(mins_unique, trip_count, label='Trips')    
    plt.xlabel("Mins")
    # plt.xticks(mins_unique)
    plt.xticks(np.arange(min(mins_unique), max(mins_unique)+1, 2), rotation='vertical')
    plt.ylabel("Number of trips")
    plt.title('Trip duration')
    plt.legend()
    plt.show()


def distance_time(df, dp):
    # plt.bar(df.trip_distance.head(dp), df.trip_time_in_mins.head(dp), label='Distance vs Time')
    plt.scatter(df.trip_distance.head(dp), df.trip_time_in_mins.head(dp), label='data', c='b')
    plt.xlabel("Distance (kms)")
    plt.ylabel("Time (mins)")
    plt.title('Distance vs Time')
    plt.legend()
    plt.show()


def pickup_location_heatmap(df, dp):
    # Manually set co-oridinate limits    
    xlim = [-74.2, -73.75]
    ylim = [40.6, 40.9]
    df = df[['pickup_longitude', 'pickup_latitude']]
    df = df[df['pickup_longitude'] >= xlim[0]]
    df = df[df['pickup_longitude'] <= xlim[1]]
    df = df[df['pickup_latitude'] >= ylim[0]]
    df = df[df['pickup_latitude'] <= ylim[1]]
    x = df.pickup_longitude.head(dp)
    y = df.pickup_latitude.head(dp)
    heatmap, xedges, yedges = np.histogram2d(x, y, bins=500)
    extent = [xedges[0], xedges[-1], yedges[0], yedges[-1]]
    plt.clf()
    plt.xlabel("Longitude")
    plt.ylabel("Latitude")
    plt.title('Pickup location')
    plt.imshow(heatmap.T, extent=extent, origin='lower')
    plt.colorbar()
    plt.show()


def trips_per_hour(df):
    df['hour_of_day'] = df.pickup_datetime.dt.hour
    hour_unique = list(df.hour_of_day.unique())
    hour_count = list(df.groupby(['hour_of_day'])['hour_of_day'].count())
    plt.bar(hour_unique, hour_count, label='Trips')
    plt.bar(hour_unique[hour_count.index(max(hour_count))],
            hour_count[hour_count.index(max(hour_count))], label='Max pickups', color='g')
    plt.bar(hour_unique[hour_count.index(min(hour_count))],
            hour_count[hour_count.index(min(hour_count))], label='Min pickups', color='r')
    plt.xlabel("Hour")
    plt.xticks(hour_unique)
    plt.ylabel("Number of trips")
    plt.title('Trips per hour of day')
    plt.legend()
    plt.show()


def trips_per_day(df):
    # df['day_of_week'] = df.pickup_datetime.dt.day_name()
    df['day_of_week'] = df.pickup_datetime.dt.dayofweek
    day_unique = [_ for _ in range(1, 8)]
    num_days = list(df.groupby(['day_of_week'])['day_of_week'].count())
    plt.bar(day_unique, num_days, label='Trips')
    plt.bar(day_unique[num_days.index(max(num_days))],
            num_days[num_days.index(max(num_days))], label='Max pickups', color='g')
    plt.bar(day_unique[num_days.index(min(num_days))],
            num_days[num_days.index(min(num_days))], label='Min pickups', color='r')
    plt.xlabel("Day of week")
    plt.xticks(day_unique, ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
    # ax = df.plot()
    # ax.set_xticks(df.index)
    # ax.set_xticklabels(df.C, rotation=90)
    plt.ylabel("Number of trips")
    plt.title('Trips per day of week')
    plt.legend()
    plt.show()


def trip_duration(df):
    df['trip_time_in_mins'] = (df['trip_time_in_secs'] / 60).astype(int)
    df = df[df['trip_time_in_mins'] < 79]  # only select time less than 79 mins
    mins_unique = list(df.trip_time_in_mins.unique())
    trip_count = list(df.groupby(['trip_time_in_mins'])['trip_time_in_mins'].count())
    plt.bar(mins_unique, trip_count, label='Trips')
    plt.xlabel("Mins")
    plt.xticks(np.arange(min(mins_unique) + 1, max(mins_unique) + 1, 2), rotation='vertical')
    plt.ylabel("Number of trips")
    plt.title('Trip duration')
    plt.legend()
    plt.show()


def distance_time(df, dp):
    df['trip_time_in_mins'] = (df['trip_time_in_secs'] / 60).astype(int)
    df['speed'] = (df['trip_distance'] * 1000 / df['trip_time_in_secs']) * 3.6  # speed (km/h)
    df = df[df['speed'] > 1]  # reject super slow moving taxis (<5 km/h)
    df = df[df['speed'] < 50]  # reject fast moving taxis (>50 km/h)
    # plt.bar(df.trip_distance.head(dp), df.trip_time_in_mins.head(dp), label='Distance vs Time')
    plt.scatter(df.trip_distance.head(dp), df.trip_time_in_mins.head(dp), label='data', c='b')
    plt.xlabel("Distance (kms)")
    plt.ylabel("Time (mins)")
    plt.title('Distance vs Time')
    plt.legend()
    plt.show()

if __name__ == "__main__":
    start_main = time()  
    fname = 'data'
    df = read_pickle(fname)
    dp = 10000  # data-points
    # print('Data Points', dp)
    # print(df.head())
    # print(df.describe())
    # print(df.dtypes)
    
    # pickup_location_heatmap(df, df.id.count())  # map with all the data
    # trips_per_hour(df)  # peak/slump hours
    # trips_per_day(df)  # trips per day of week
    # trip_duration(df)  # mins vs num_of_trips
    distance_time(df, dp)  # speed

    print("Run time:", "{:.2f}".format((time()-start_main)/60), "mins")
