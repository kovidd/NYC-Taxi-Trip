# -*- coding: utf-8 -*-
"""
Created on Thu Mar  4 17:06:58 2021

@author: Kovid
"""

from datetime import timedelta


def seconds_to_text(secs):
    days = secs//86400
    hours = (secs - days*86400)//3600
    minutes = (secs - days*86400 - hours*3600)//60
    seconds = secs - days*86400 - hours*3600 - minutes*60
    result = ("{0} day{1} ".format(days, "s" if days != 1 else "") if days else "") + \
             ("{0} hr{1} ".format(hours, "s" if hours != 1 else "") if hours else "") + \
             ("{0} min{1} ".format(minutes, "s" if minutes != 1 else "") if minutes else "") + \
             ("{0} sec{1} ".format(seconds, "s" if seconds != 1 else "") if seconds else "")
    return result


def seconds_to_text_(secs):
    sec = timedelta(seconds=int(secs))
    result = str(sec)
    return result


if __name__ == "__main__":
    secs = 1000
    res = seconds_to_text(secs)
    print(res)

    secs = 1000
    res = seconds_to_text_(secs)
    print(res)
