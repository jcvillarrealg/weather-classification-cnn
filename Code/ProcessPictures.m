clear
%Identify the images to process
files = dir('../Dataset/Cloudy/*.jpg')
%Variable with the directory where images came from
origin_dir = string('../Dataset/Cloudy/');
%Directory where the processed images will be saved
directory = string('../Dataset/Cloudy_SP/');
%Number of desired pixels to add to the images
iNumPixels = 100;
%counter to indicate the names of the images
count = 1;
for file = files'
    %Identifying the name of the current image
    aux = file.name;
    %Reading the file with the current image
    A =imread(char(strcat(origin_dir,string(aux))));
    %Using the custom image that adds the pixels and saves the image
    drawsuperpixelsonimage(A,iNumPixels,count,directory);
    aux = '';
    count = count + 1;
end