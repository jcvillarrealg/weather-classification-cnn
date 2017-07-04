
"""

FindDuplicates.py
	Python script designed to go over a list of 
	URLs linking to images for the dataset,
	making sure that there are no duplicate URLs
	Preconditions:
		2 Files with a list of URLs with potential duplicates
	Postconditions:
		1 File with a list of non-duplicated URLs

"""

print("What is the name of the original file?")
orig_file = raw_input()

print("What is the name of the new file")
new_file = raw_input()

print("What name should the file without duplicates have?")
non_dup_name = raw_input()

#File for file withou duplicates
non_dup_file = open(non_dup_name, "w")

#Set to add links
links = set()

#Add the links from original file
with open(orig_file) as f_orig:
	for line in f_orig:
		links.add(line)

#Check the links from new file
with open(new_file) as f_new:
	for line in f_new:
		if line not in links:
			links.add(line)
			non_dup_file.write(line)
		else:
			print("Found Duplicate")

non_dup_file.close()
