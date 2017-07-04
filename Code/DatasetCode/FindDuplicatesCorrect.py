"""

FindDuplicatesCorrect.py
	Python script designed to go over a list of 
	URLs linking to images for the dataset,
	making sure that there are no duplicate URLs.
	This code is designed to work only with flickr

	Preconditions:
		1 Files with a list of URLs with potential duplicates
	Postconditions:
		1 File with a the numbers of images that are duplicated
		for further manual deleting 

"""

# Required imports
from lxml import html
import requests
import urllib

# Set to add links, without considering duplicates
images = set()
images_urls = set()

# Request the name of relevant files to the user
print("What is the name of the file that contains the urls?")
urls_file = raw_input()

print("What should be the name of the file containing the number of duplicate images?")
dupe_file = raw_input()

# Counter track the number of images
count = 1

# List to load the urls to check
urls = []

# Getting the URLs from the indicated file
with open(urls_file) as file_obj:
	lines = file_obj.readlines()

urls = [line.strip() for line in lines]

count = int(count)-1

# Creating the file to store the URLs
info_file = open(dupe_file, "w")

# Iterate over the URLs
for url in urls:
	count += 1

	# Considering only images from flickr
	if "https://www.flickr" not in url:
		continue

	# Accessing the web page linked to the URL
	page = requests.get(url)

	# Parsing the HTML structure into a python object
	tree = html.fromstring(page.content)

	# Extracting the link to the original image
	image_url = tree.xpath("//head/meta[@property='og:image']/@content")[0]

	# Adding the url to the image making sure it does not
	#	already exists
	if image_url not in images_urls:
		images_urls.add(image_url)
	else:
		# Indicate that a duplicate image was found
		info_file.write(str(count)+'\n')

# Closing the file that contains the numbers for the duplicated images
info_file.close()
