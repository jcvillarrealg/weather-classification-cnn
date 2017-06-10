
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
	for line in file_obj:
		if line not in urls:
			urls.append(line.strip())

count = int(count)-1

pending_urls = []

pending_file = open(pending_filename, "w")
info_file = open(info_filename, "w")


info_file.write("FileName,Title,Author,License,Comments,URL")


for url in urls:


	count += 1

	# In[2]:

	page = requests.get(url)


	# In[3]:

	tree = html.fromstring(page.content)


	# In[10]:

	#Author
	try:
		author = tree.xpath("//div/div/div/a[@class='hover_opacity']/text()")[0].strip() 
		author = author[0:author.index('/')].strip()
	except:
		author = "Not Provided"
	print("Author " + author)

	# In[11]:

	#Title
	title = "Not Provided"

	# In[16]:

	#License
	license = "https://creativecommons.org/publicdomain/zero/1.0/deed.en"

	#Image URL
	image_url = tree.xpath("//div/div/div/div/div/img/@src")[0]


	# In[31]:

	#Image Download
	urllib.urlretrieve(image_url, str(count).rjust(4, '0') + ".jpg")

	#Writing info of the image
	#FileName,Title,,Author,License,Comments,URL
	saux = "\n" + str(count).rjust(4, '0') + ".jpg" + "," + title + "," + author + "," + license + ",No Changes" + "," + url

	info_file.write(saux.encode("utf-8"))

info_file.close()
pending_file.close()

