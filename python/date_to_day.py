# -*- coding: utf-8 -*-
"""
Created on Sat Mar  6 10:53:59 2021

@author: Kovid
"""

from datetime import date


def get_day(str_date):
    y, m, d = map(int, str_date.split('-'))
    day_name = (date(y, m, d)).strftime("%A")
    return day_name


if __name__ == "__main__":
    day_name = get_day('2013-02-04')
    print(day_name)

    day_name = get_day('2013-02-10')
    print(day_name)
