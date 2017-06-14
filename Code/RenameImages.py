#	Python script to rename images from 0001.jpg to 0nnn.jpg where nnn
#		is the number of images contained in the given directory

import sys
import os

print("What is the directory were the images to rename are located?")
direct = raw_input()

count = 1

#Finding all the jpg files in the directory
for file in os.listdir(direct):
    if file.endswith(".jpg"):
        print(file)
