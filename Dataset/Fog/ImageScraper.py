
# coding: utf-8

# In[27]:

from lxml import html
import requests
import urllib

print("What is the name of the file that contains the urls?")
urls_file = raw_input()

print("What should be the name of the file containing the pending urls?")
pending_filename = raw_input()

print("What should be the name of the file containing the information of the images?")
info_filename = raw_input()

print("What should be the number for the first image?")
count = raw_input()

urls = []

with open(urls_file) as file_obj:
	lines = file_obj.readlines()

urls = [line.strip() for line in lines]

count = count-1

pending_urls = []

pending_file = open(pending_filename, "w")
info_file = open(info_filename, "w")


info_file.write("FileName,Title,Author,License,Comments,URL")



for url in urls:

	if "https://www.flickr" not in url:
		pending_file.write(url+"\n")
		continue

	count += 1

	# In[2]:

	page = requests.get(url)


	# In[3]:

	tree = html.fromstring(page.content)


	# In[10]:

	#Author
	try:
		author = tree.xpath("//div[@class='attribution-info']/a/text()")[0]
	except:
		title = "Not Provided"

	# In[11]:

	#Title
	try:
		title = tree.xpath("//head/meta[@property='og:title']/@content")[0]
	except:
		title = "Not Provided"

	# In[16]:

	#License
	try:
		license = tree.xpath("//div[@class='photo-license-info']/a/@href")[0]
	except:
		title = "Not Provided"

	# In[29]:

	#Image URL
	image_url = tree.xpath("//head/meta[@property='og:image']/@content")[0]


	# In[31]:

	#Image Download
	urllib.urlretrieve(image_url, str(count).rjust(4, '0') + ".jpg")

	#Writing info of the image
	#FileName,Title,,Author,License,Comments,URL
	saux = "\n" + str(count).rjust(4, '0') + ".jpg" + "," + title + "," + author + "," + license + ",No Changes" + "," + url

	info_file.write(saux.encode("utf-8"))

info_file.close()
pending_file.close()

