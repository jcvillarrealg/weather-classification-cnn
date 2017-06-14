
# coding: utf-8

# In[1]:

import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import caffe


# In[2]:

caffe.set_mode_cpu()


# In[3]:

model = 'bvlc_googlenet'
model_dir = '../models/%s' % model
print(model_dir)


# In[4]:

#Loading data from model
import os
net_model = ""
net_weights = ""
for file in os.listdir(model_dir):
    if file.endswith("deploy.prototxt"):
        net_model = os.path.join(model_dir, file)


# In[15]:

for file in os.listdir(model_dir):
    if file.endswith(".caffemodel"):
        print(os.path.join(model_dir, file))
        net_weights = os.path.join(model_dir, file)


# In[16]:

print(net_model)
print(net_weights)


# In[ ]:

phase = 'test'


# In[17]:

#Initialising a network
net = caffe.Net(net_model,
                net_weights,
                caffe.TEST)


# In[22]:

# Some models require the dimensions of the images to be 224x224 while others require 227x227 
if model == 'bvlc_alexnet' or model == 'bvlc_reference_caffenet' or model == 'bvlc_reference_rcnn_ilsvrc13' or model == 'placesCNN':
    net.blobs['data'].reshape(1,3,227,227)
else:
    net.blobs['data'].reshape(1,3,224,224)


# In[30]:

dataset = 'ExtendedWeatherDatabase'
category = 'cloudy'
datasets_dir = '../matlab/demo'
pos_train_dir = datasets_dir + "/datasets/%s/POS_TRAIN/%s" % (dataset, category)
count = 0
for file in os.listdir(pos_train_dir):
    if file.endswith(".jpg"):
        count = count + 1
pos_num_train_images = count
count = 0
neg_train_dir = datasets_dir + "/datasets/%s/NEG_TRAIN/%s" % (dataset, category)
for file in os.listdir(neg_train_dir):
    if file.endswith(".jpg"):
        count = count + 1
neg_num_train_images = count
count = 0
pos_test_dir = datasets_dir + "/datasets/%s/POS_TEST/%s" % (dataset, category)
for file in os.listdir(pos_test_dir):
    if file.endswith(".jpg"):
        count = count + 1
pos_num_test_images = count
count = 0
neg_test_dir = datasets_dir + "/datasets/%s/NEG_TEST/%s" % (dataset, category)
for file in os.listdir(neg_test_dir):
    if file.endswith(".jpg"):
        count = count + 1
neg_num_test_images = count
print(pos_num_train_images)
print(neg_num_train_images)
print(pos_num_test_images)
print(neg_num_test_images)


# In[ ]:



