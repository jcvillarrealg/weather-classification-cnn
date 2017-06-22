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
predefined = true;
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
directoriesforspimages = [];
for i = 1:1:numel(categories)
    directoryoriginaux = string(sprintf('../Dataset/%s/', categories(i)));
    directoryfinalaux = string(sprintf('../Dataset/%s_marked/', categories(i)));
   directoriesforspimages = [directoriesforspimages directoryfinalaux];
   origindirectories = [origindirectories directoryoriginaux];
end

% If the number of superpixels is above 0, then we most process the images
if numsuperpixels > 0
    database = 'ExtendedWeatherDatabase_SP';
    for i = 1:1:numel(categories)
       processpictures(origindirectories(i), directoriesforspimages(i), numsuperpixels)
    end
    % The ExtendedWeatherDatabase with the required format must be built
    if predefined
        %Load the images from the 'marked' folders
        ewd_spbasedir = sprintf('../%s/', database);
        %Copy to POS_TRAIN subdirectory
        for i = 1:numel(categories)
           for j = 1:770
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(i), sprintf('%04d',j)), [ewd_spbasedir sprintf('POS_TRAIN/%s/', categories(i))]);
           end
        end
        %Copy to POS_TEST subdirectory
        for i = 1:numel(categories)
           for j = 771:1100
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(i), sprintf('%04d',j)), [ewd_spbasedir sprintf('POS_TEST/%s/', categories(i))]);
           end
        end
        %Copy to NEG_TRAIN subdirectory
        for i = 1:numel(categories)
           %Take 1-193
           k = (1 + mod(i+1-1, numel(categories)));
           for j = 1:193
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TRAIN/%s/', categories(i))]);
           end
           
           %Take 194-386
           k = (1 + mod(i+2-1, numel(categories)));
           for j = 194:386
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TRAIN/%s/', categories(i))]);
           end
           
           %Take 387-578
           k = (1 + mod(i+3-1, numel(categories)));
           for j = 387:578
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TRAIN/%s/', categories(i))]);
           end
           
           %Take 579-770
           k = (1 + mod(i+4-1, numel(categories)));
           for j = 579:770
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TRAIN/%s/', categories(i))]);
           end
        end

        %Copy to NEG_TEST subdirectory
        for i = 1:numel(categories)
           %Take 771-853
           k = (1 + mod(i+1-1, numel(categories)));
           for j = 771:853
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TEST/%s/', categories(i))]);
           end
           
           %Take 854-936
           k = (1 + mod(i+2-1, numel(categories)));
           for j = 854:936
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TEST/%s/', categories(i))]);
           end
           
           %Take 937-1018
           k = (1 + mod(i+3-1, numel(categories)));
           for j = 937:1018
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TEST/%s/', categories(i))]);
           end
           
           %Take 1019-1100
           k = (1 + mod(i+4-1, numel(categories)));
           for j = 1019:1100
               copyfile(sprintf('../Dataset/%s_marked/%s.jpg',categories(k), sprintf('%04d',j)), [ewd_spbasedir sprintf('NEG_TEST/%s/', categories(i))]);
           end
        end
    end
end


%Extract features with selected model
%Directory for extracted features -> ../extractedFeatures/
features_base_dir = '../extractedFeatures/';

if numsuperpixels > 0
   %If there are superpixels, the images are in drectoriesforspimages directories 
   for i=1:numel(models)
       for j = 1:numel(categories)
            current_dir = string(features_base_dir) + string(sprintf('%s/%s/', models(i), categories(j)));
            [code, code_v, code_neg, code_v_neg] = matdeeprep(char(models(i)), 'ExtendedWeatherDatabase_SP', char(categories(j)));
        
        save(char(current_dir + string('positive_train_features.mat')), 'code');
        save(char(current_dir + string('positive_test_features.mat')), 'code_v');
        save(char(current_dir + string('negative_train_features.mat')), 'code_neg');
        save(char(current_dir + string('negative_test_features.mat')), 'code_v_neg');
            
        code = [];
        code_v = [];
        code_neg = [];
        code_v_neg = [];
        
       end
   end
else
    %If there are no superpixels, the images are in the origindirectories
    %directories
    for i=1:numel(models)
       for j = 1:numel(categories)
            current_dir = string(features_base_dir) + string(sprintf('%s/%s/', models(i), categories(j)));
            [code, code_v, code_neg, code_v_neg] = matdeeprep(char(models(i)), 'ExtendedWeatherDatabase', char(categories(j)));
        
        save(char(current_dir + string('positive_train_features.mat')), 'code');
        save(char(current_dir + string('positive_test_features.mat')), 'code_v');
        save(char(current_dir + string('negative_train_features.mat')), 'code_neg');
        save(char(current_dir + string('negative_test_features.mat')), 'code_v_neg');
            
        code = [];
        code_v = [];
        code_neg = [];
        code_v_neg = [];
        
       end
   end
end


%Train and Test Classifier with extracted features
% For each model 
for i = (1:1:length(models))
    disp(fprintf('[LOG] Model %s \n', models(i)))
% For each category
    for j = (1:1:length(categories))
        disp(fprintf('[LOG] Category %s \n', categories(j)))
% Train the classifier, getting is results as output
    % Average Precision is in the info.auc struct
        mkdir(sprintf('../IntermediateResults/%s/', runid));
        base_dir = sprintf('../IntermediateResults/%s/%s/%s/', runid, models(i), categories(j));
        mkdir(base_dir);
        [train_w,train_bias,train_scores,test_scores,info]=WeatherClassifier_TwoClass(models(i), categories(j), images_type, C);
        disp(sprintf('Model %s for category %s has AP of %s', models(i), categories(j), info.auc))
        save([base_dir 'results.mat'],'train_w','train_bias','train_scores','test_scores','info');
        clear train_w train_bias test_w test_bias train_scores test_scores info;
  % Save results to a file
    end
end

%Write results to CSV file
%   This script generates a CSV files with the results of the experiment
%   found in the results folders in the directroy of the project
%   After the execution of this file, a CSV file is created with name
%   WeatherClassification_Results.csv 
%   In the CSV file, each column is a different model used for the feature
%   extraction and each line is one of the different categories
%   The columns have the models in the following order:
%   'bvlc_googlenet','placesCNN','ResNet50','ResNet101','ResNet152','VGG_CNN_F','VGG_CNN_M','VGG_CNN_S','VGGNet16','VGGNet19'
%   The rows have the categories in the following order:
%   'cloudy' (first row),'foggy'(second row),'rainy' (third row),'snowy','sunny'
%   The results show the average precision for each case

results = sprintf('../IntermediateResults/%s/', runid);

complete_values = []; % Variable to store the complete set of results
ap_values = []; % Variable to store the results of each row
% Load results
for i = 1:1:size(categories,2)
    for j = 1:1:size(models,2)
        res = load([results sprintf('%s/%s/results.mat',models(j), categories(i))]);
        ap_values = [ap_values res.info.ap];
    end
    complete_values = vertcat(complete_values, ap_values);
    ap_values = [];
end
finalresultsdir = sprintf('../FinalResults/%s/', runid);
mkdir(finalresultsdir);
csvwrite(finalresultsdir, complete_values);

end
