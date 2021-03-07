# -*- coding: utf-8 -*-
"""
Created on Thu Mar  4 13:50:45 2021

@author: Kovid
"""

import hashlib

result = hashlib.md5(b'5433881')
# printing the equivalent byte value.
print("The byte equivalent of hash is : ", end="")
print(result.hexdigest()) #BA96DE419E711691B9445D6A6307C170
