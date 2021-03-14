# -*- coding: utf-8 -*-
"""
Created on Thu Mar  4 15:33:07 2021

@author: Kovid
"""

from math import sin, cos, sqrt, atan2, radians
import geopy.distance

# approximate radius of earth in km
R = 6373.0

lat1 = radians(40.645657)
lon1 = radians(-73.791359)
lat2 = radians(40.758766)
lon2 = radians(-73.922501)

dlon = lon2 - lon1
dlat = lat2 - lat1

a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
c = 2 * atan2(sqrt(a), sqrt(1 - a))

distance = R * c

print("Result:", distance)
print("Should be:", 14.58, "km")

######################################
lat1 = radians(40.756237)
lon1 = radians(-73.975372)
lat2 = radians(40.721886)
lon2 = radians(-73.867119)

dlon = lon2 - lon1
dlat = lat2 - lat1

a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
c = 2 * atan2(sqrt(a), sqrt(1 - a))

distance = R * c

print("Result:", distance)
print("Should be:", 7.70, "km")
print()


# Using geopy

coords_1 = (40.756237, -73.975372)
coords_2 = (40.721886, -73.867119)
print("Result:", geopy.distance.distance(coords_1, coords_2).km, "km")
print("Should be:", 7.70, "km\n")

coords_1 = (40.645657, -73.791359)
coords_2 = (40.758766, -73.922501)
print("Result:", geopy.distance.distance(coords_1, coords_2).km, "km")
print("Should be:", 14.58, "km\n")

coords_1 = (47.597229, -77.764572)
coords_2 = (47.597229, -77.764572)
print("Result:", geopy.distance.distance(coords_1, coords_2).km, "km\n")

coords_1 = (40.756439, -2001.505100)
coords_2 = (40.751781, -73.986183)
print("Result:", geopy.distance.distance(coords_1, coords_2).km, "km")
print("Should be:", 0.66, "km\n")
