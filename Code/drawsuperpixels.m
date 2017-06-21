function drawsuperpixels( arrImagesNames, iNumPixels)
%drawsuperpixels Draw Superpixels on each image in the specified range
%   Detailed explanation goes here
count = 1
for i = arrImagesNames
    A =imread(char(i));
    [L,N] = superpixels(A,iNumPixels);
    BW = boundarymask(L);
    f = figure('visible', 'off')
    imshow(imoverlay(A,BW,'cyan'),'InitialMagnification',67)
    saveas(f,char(pad(string(count),4,'left','0')),'jpg')
    count = count + 1
end
bValue = true
end

