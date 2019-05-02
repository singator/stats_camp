# -*- coding: utf-8 -*-
"""
Created on Sat Apr  1 16:48:21 2017

@author: stavg
"""

import serial
import csv

ser = serial.Serial('COM6', 9600, timeout=2)
y2=[]

while True:
    try:
        y = ser.readline()
        print(y)
        y2.append(y.decode().strip()) # remove the trailing characters
        
    except KeyboardInterrupt:
        break

ser.close()

y2 = [x.split(',') for x in y2]

with open('some.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['HR', 'Time.ms'])
    writer.writerows(y2[1:])
    
