function drawsuperpixelsonimage( imageFile, iNumPixels, count, directory)
%drawsuperpixels Draw Superpixels on each image in the specified range
%   Detailed explanation goes here
A =imageFile;
[L,N] = superpixels(A,iNumPixels);
BW = boundarymask(L);
f = figure('visible', 'off');
iptsetpref('ImshowBorder','tight');
imshow(imoverlay(A,BW,'white'))
saveas(f,char(strcat(directory,pad(string(count),4,'left','0'))),'jpg')
end

