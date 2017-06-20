
% Define parameters
num_superpixels = 50; %Number of superpixels for the images
C = 10; %Classifier constant
models = [string('bvlc_googlenet'),string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];
categories = [string('cloudy'), string('foggy'), string('rainy'), string('snowy'), string('sunny')];
curr_model = 1;
curr_category = 1;

%Identify images (without superpixels)
%   Find the corresponding directory


%Mark images with superpixels
%   use the script called ProcessPictures.m




%Extract features with selected model
%   Allow an option for all models perhaps when value of curr_model is -1
%   Allow an option for all categories perhaps when value of curr_categories is -1


%Train and Test Classifier with extracted features


%Display results and save in a convenient lication
