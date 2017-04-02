# -*- coding: utf-8 -*-
"""
@author: stavg
"""

import sys
import csv
import numpy as np

if __name__=='__main__':
  x = [[1,2], [3,4]]

  with open(sys.argv[1], 'w', newline='') as f:
      writer = csv.writer(f)
      writer.writerows(x)
    
