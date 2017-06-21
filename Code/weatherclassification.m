% weatherclassification
%       Function that trains a series of classifiers using different models
%       as feature extractors

% Parameters
%   models - array of strings specifying the models to use
%   categories - array of the categories to be used for the current
%       iteration
%   superpixels - number of superpixels to use (0 if no superpixels are to
%       be used
%   C - constant for the classifier
%   runid - char sequence to identify a given execution of the script


function weatherclassification(models, categories, numsuperpixels, C, runid)

addpath('../../../caffe/matlab/demo/');
% Define parameters
numsuperpixels = 50; %Number of superpixels for the images
C = 10; %Classifier constant
%models = [string('bvlc_googlenet'),string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];
%categories = [string('cloudy'), string('foggy'), string('rainy'), string('snowy'), string('sunny')];
curr_model = 1;
curr_category = 1;

%Identify images (without superpixels)
%   Find the corresponding directory


%Mark images with superpixels
%   use the script called ProcessPictures.m
%If we are using superpixels, then mark images with corresponding
%superpixels
origindirectories = [];
directoriesforimages = [];
for i = 1:1:numel(categories)
    directoryoriginaux = string(sprintf('../Dataset/%s/', categories(i)));
    directoryfinalaux = string(sprintf('../Dataset/%s_marked/', categories(i)));
   directoriesforspimages = [directoriesforimages directoryfinalaux];
   origindirectories = [origindirectories directoryoriginaux];
end

% If the number of superpixels is above 0, then we most process the images
if numsuperpixels > 0
    for i = 1:1:numel(categories)
       processpictures( origindirectories(i), directoriesforspimages(i), numsuperpixels)
    end
end


%Extract features with selected model
%Directory for extracted features -> ../extractedFeatures/
featuresdirectory = '../extractedFeatures/';
for i = 1:1:numel(models)
    for j=1:1:numel(categories)
        disp(fprintf('[LOG] Category %s \n', categories(j)))
        %For each model and each of its categories, extract features and
        %save them to a file
        current_dir = string(features_base_dir) + string(sprintf('%s/%s/', models(i), categories(j)));
        disp(current_dir)
        [code, code_v, code_neg, code_v_neg] = matdeeprep(char(models(i)), 'ExtendedWeatherDatabase', char(categories(j)));
        
        save(char(current_dir + string('_positive_train_features.mat')), 'code');
        save(char(current_dir + string('_positive_test_features.mat')), 'code_v');
        save(char(current_dir + string('_negative_train_features.mat')), 'code_neg');
        save(char(current_dir + string('_negative_test_features.mat')), 'code_v_neg');
        
        code = [];
        code_v = [];
        code_neg = [];
        code_v_neg = [];
        
    end
end


%Train and Test Classifier with extracted features


%Display results and save in a convenient lication

end
