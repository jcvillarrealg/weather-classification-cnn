%% ProcessResults.m
%   This script generates a CSV files with the results of the experiment
%   found in the results folders in the directroy of the project
%   After the execution of this file, a CSV file is created with name
%   WeatherClassification_Results.csv 
%   In the CSV file, each column is a different model used for the feature
%   extraction and each line is one of the different categories
%   The columns have the models in the following order:
%   'bvlc_googlenet','placesCNN','ResNet50','ResNet101','ResNet152','VGG_CNN_F','VGG_CNN_M','VGG_CNN_S','VGGNet16','VGGNet19'
%   The rows have the categories in the following order:
%   'cloudy','foggy','rainy','snowy','sunny'
%   The results show the average precision for each case
% Identify Results
results_superpixels_dir = '../results_superpixels/';
results_normal_dir = '../results_normal/';
models = [string('bvlc_googlenet'),string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];
categories = [string('cloudy'), string('foggy'), string('rainy'), string('snowy'), string('sunny')];

complete_values = []; % Variable to store the complete set of results
ap_values = []; % Variable to store the results of each row

prompt = 'What is the base directory of the results to be processed? ';
baseDir = input(prompt);

% Load results
for i = 1:1:size(categories,2)
    for j = 1:1:size(models,2)
        res = load([baseDir sprintf('%s/%s/results.mat',models(j), categories(i))]);
        ap_values = [ap_values res.info.ap];
    end
    complete_values = vertcat(complete_values, ap_values);
    ap_values = [];
end
prompt='What should be the file name? ';
fileName = input(prompt);
csvwrite(['../results_final/' fileName], complete_values);

        