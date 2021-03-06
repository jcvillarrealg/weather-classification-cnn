from lxml import html
import requests
import urllib

#Set to add links
images = set()
images_urls = set()

print("What is the name of the file that contains the urls?")
urls_file = raw_input()

print("What should be the name of the file containing the number of duplicate images?")
dupe_file = raw_input()

count = 1

urls = []

with open(urls_file) as file_obj:
	lines = file_obj.readlines()

urls = [line.strip() for line in lines]

count = int(count)-1

pending_urls = []

info_file = open(dupe_file, "w")


for url in urls:

	count += 1

	if "https://www.flickr" not in url:
		continue


	# In[2]:

	page = requests.get(url)


	# In[3]:

	tree = html.fromstring(page.content)


	#Image URL
	image_url = tree.xpath("//head/meta[@property='og:image']/@content")[0]

	if image_url not in images_urls:
		images_urls.add(image_url)
	else:
		#Duplicate image
		info_file.write(str(count)+'\n')


info_file.close()
