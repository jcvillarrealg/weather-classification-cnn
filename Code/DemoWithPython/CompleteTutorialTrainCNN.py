
# coding: utf-8

# In[1]:

#Load the imports/binaries
# make sure that caffe is in our import path
import sys
sys.path.insert(0, './python')
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import caffe


# In[2]:

#Set mode to CPU
caffe.set_mode_cpu()


# In[ ]:

#load the model
net = caffe.Net('models/bvlc_reference_caffenet/deploy.prototxt',
                'models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel',
                caffe.TEST)


# In[ ]:

# load input and configure preprocessing
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_mean('data', np.load('python/caffe/imagenet/ilsvrc_2012_mean.npy').mean(1).mean(1))
transformer.set_transpose('data', (2,0,1))
transformer.set_channel_swap('data', (2,1,0))
transformer.set_raw_scale('data', 255.0)


# In[ ]:

#note we can change the batch size on-the-fly
#since we classify only one image, we change batch size from 10 to 1
net.blobs['data'].reshape(1,3,227,227)


# In[ ]:

#load the image in the data layer
im = caffe.io.load_image('examples/images/cat.jpg')
net.blobs['data'].data[...] = transformer.preprocess('data', im)


# In[ ]:

#compute
out = net.forward()


# In[ ]:

print(out)


# In[ ]:

#predicted predicted class
print out['prob'].argmax()


# In[ ]:

#print predicted labels
labels = np.loadtxt("data/ilsvrc12/synset_words.txt", str, delimiter='\t')
top_k = net.blobs['prob'].data[0].flatten().argsort()[-1:-6:-1]
print labels[top_k]


# In[ ]:

"""Load the solver in python"""
solver = caffe.get_solver('models/bvlc_reference_caffenet/solver.prototxt')


# In[ ]:

ls ./models/bvlc_reference_caffenet/

