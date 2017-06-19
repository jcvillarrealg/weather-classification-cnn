%Function 
function [train_w,train_bias,train_scores,test_scores,info] = WeatherClassifier_TwoClass(model, category, images_type, C)

%Adding path to the features
%   To change features with and without SP, change next line of code
%   features - features for images with superpixels
%   featuresNormal - features for images without superpixels
if isequal(images_type, 'superpixel')
    addpath('/Users/JoseCarlosVillarreal/Documents/DissertationDevelopment/weather-classification-cnn/features/');
else
    if isequal(images_type, 'normal')
        addpath('/Users/JoseCarlosVillarreal/Documents/DissertationDevelopment/weather-classification-cnn/featuresNormal/');
    else 
        error('images_type must contain the value ''superpixel'' or ''normal''');
    end
end

models = [string('bvlc_googlenet'),string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];
categories = [string('cloudy'), string('foggy'), string('rainy'), string('snowy'), string('sunny')];
number_features = [9216 4096 18432 18432 18432 4096 4096 4096 4096 4096];

%%IMPORTANT VARIABLES TO CHANGES ON EACH RUN
model_to_use = strfind(models, model);
category_to_use = strfind(categories,category);
curr_model = 0;
curr_category = 0;
for i = 1:1:size(model_to_use,2)
    if ~isempty(model_to_use{i})
        curr_model = i;
    end
end
for i = 1:1:size(category_to_use,2)
    if ~isempty(category_to_use{i})
        curr_category = i;
    end
end
clear i

%Loading data
%pos_train, neg_train, pos_test, neg_test

%Cloudy Category
pos_train_cloudy = load(['../features/' model '/' char(category(curr_category)) '/_positive_train_features.mat']) ;
neg_train_cloudy = load(['../features/' model '/' char(category(curr_category)) '/_negative_train_features.mat']) ;
pos_test_cloudy = load(['../features/' model '/' char(category(curr_category)) '/_positive_test_features.mat']) ;
neg_test_cloudy = load(['../features/' model '/' char(category(curr_category)) '/_negative_test_features.mat']) ;

pos_train_cloudy = pos_train_cloudy.code ;
neg_train_cloudy = neg_train_cloudy.code_neg ;
pos_test_cloudy = pos_test_cloudy.code_v ;
neg_test_cloudy = neg_test_cloudy.code_v_neg ;

%{
%Foggy Category
pos_train_foggy = load(['../features/' model '/' char(category(2)) '/_positive_train_features.mat']) ;
neg_train_foggy = load(['../features/' model '/' char(category(2)) '/_negative_train_features.mat']) ;
pos_test_foggy = load(['../features/' model '/' char(category(2)) '/_positive_test_features.mat']) ;
neg_test_foggy = load(['../features/' model '/' char(category(2)) '/_negative_test_features.mat']) ;

pos_train_foggy = pos_train_foggy.code ;
neg_train_foggy = neg_train_foggy.code_neg ;
pos_test_foggy = pos_test_foggy.code_v ;
neg_test_foggy = neg_test_foggy.code_v_neg ;

%Rainy Category
pos_train_rainy = load(['../features/' model '/' char(category(3)) '/_positive_train_features.mat']) ;
neg_train_rainy = load(['../features/' model '/' char(category(3)) '/_negative_train_features.mat']) ;
pos_test_rainy = load(['../features/' model '/' char(category(3)) '/_positive_test_features.mat']) ;
neg_test_rainy = load(['../features/' model '/' char(category(3)) '/_negative_test_features.mat']) ;

pos_train_rainy = pos_train_rainy.code ;
neg_train_rainy = neg_train_rainy.code_neg ;
pos_test_rainy = pos_test_rainy.code_v ;
neg_test_rainy = neg_test_rainy.code_v_neg ;

%Snowy Category
pos_train_snowy = load(['../features/' model '/' char(category(4)) '/_positive_train_features.mat']) ;
neg_train_snowy = load(['../features/' model '/' char(category(4)) '/_negative_train_features.mat']) ;
pos_test_snowy = load(['../features/' model '/' char(category(4)) '/_positive_test_features.mat']) ;
neg_test_snowy = load(['../features/' model '/' char(category(4)) '/_negative_test_features.mat']) ;

pos_train_snowy = pos_train_snowy.code ;
neg_train_snowy = neg_train_snowy.code_neg ;
pos_test_snowy = pos_test_snowy.code_v ;
neg_test_snowy = neg_test_snowy.code_v_neg ;

%Sunny Category
pos_train_sunny = load(['../features/' model '/' char(category(5)) '/_positive_train_features.mat']) ;
neg_train_sunny = load(['../features/' model '/' char(category(5)) '/_negative_train_features.mat']) ;
pos_test_sunny = load(['../features/' model '/' char(category(5)) '/_positive_test_features.mat']) ;
neg_test_sunny = load(['../features/' model '/' char(category(5)) '/_negative_test_features.mat']) ;

pos_train_sunny = pos_train_sunny.code ;
neg_train_sunny = neg_train_sunny.code_neg ;
pos_test_sunny = pos_test_sunny.code_v ;
neg_test_sunny = neg_test_sunny.code_v_neg ;
%}

% Labels for each category
%   1 - Cloudy
%   2 - Foggy
%   3 - Rainy
%   4 - Snowy
%   5 - Sunny
%   -1 - Cloudy (Negative)
%   -2 - Foggy (Negative)
%   -3 - Rainy (Negative)
%   -4 - Snowy (Negative)
%   -5 - Sunny (Negative)

% Cloudy
labels_train_1 = ones(size(pos_train_cloudy,2),1)';
labels_train_1_neg = -1 * ones(size(neg_train_cloudy,2),1)';

labels_test_1 = ones(size(pos_test_cloudy,2),1)';
labels_test_1_neg = -1 * ones(size(neg_test_cloudy,2),1)';

%{
% Foggy
labels_train_2 = 2 * ones(size(pos_train_foggy,2),1)';
labels_train_2_neg = -2 * ones(size(neg_train_foggy,2),1)';

labels_test_2 = 2 * ones(size(pos_test_foggy,2),1)';
labels_test_2_neg = -2 * ones(size(neg_test_foggy,2),1)';

% Rainy
labels_train_3 = 3 * ones(size(pos_train_rainy,2),1)';
labels_train_3_neg = -3 * ones(size(neg_train_rainy,2),1)';

labels_test_3 = 3 * ones(size(pos_test_rainy,2),1)';
labels_test_3_neg = -3 * ones(size(neg_test_rainy,2),1)';

% Snowy
labels_train_4 = 4 * ones(size(pos_train_snowy,2),1)';
labels_train_4_neg = -4 * ones(size(neg_train_snowy,2),1)';

labels_test_4 = 4 * ones(size(pos_test_snowy,2),1)';
labels_test_4_neg = -4 * ones(size(neg_test_snowy,2),1)';

% Sunny
labels_train_5 = 5 * ones(size(pos_train_sunny,2),1)';
labels_train_5_neg = -5 * ones(size(neg_train_sunny,2),1)';

labels_test_5 = 5 * ones(size(pos_test_sunny,2),1)';
labels_test_5_neg = -5 * ones(size(neg_test_sunny,2),1)';

%}

% Adding the labels to the feature vectors
pos_train_cloudy = vertcat(pos_train_cloudy, labels_train_1);
neg_train_cloudy = vertcat(neg_train_cloudy, labels_train_1_neg);
pos_test_cloudy = vertcat(pos_test_cloudy, labels_test_1);
neg_test_cloudy = vertcat(neg_test_cloudy, labels_test_1_neg);

%{
pos_train_foggy = vertcat(pos_train_foggy, labels_train_1);
neg_train_foggy = vertcat(neg_train_foggy, labels_train_1_neg);
pos_test_foggy = vertcat(pos_test_foggy, labels_test_1);
neg_test_foggy = vertcat(neg_test_foggy, labels_test_1_neg);

pos_train_rainy = vertcat(pos_train_rainy, labels_train_1);
neg_train_rainy = vertcat(neg_train_rainy, labels_train_1_neg);
pos_test_rainy = vertcat(pos_test_rainy, labels_test_1);
neg_test_rainy = vertcat(neg_test_rainy, labels_test_1_neg);

pos_train_snowy = vertcat(pos_train_snowy, labels_train_1);
neg_train_snowy = vertcat(neg_train_snowy, labels_train_1_neg);
pos_test_snowy = vertcat(pos_test_snowy, labels_test_1);
neg_test_snowy = vertcat(neg_test_snowy, labels_test_1_neg);

pos_train_sunny = vertcat(pos_train_sunny, labels_train_1);
neg_train_sunny = vertcat(neg_train_sunny, labels_train_1_neg);
pos_test_sunny = vertcat(pos_test_sunny, labels_test_1);
neg_test_sunny = vertcat(neg_test_sunny, labels_test_1_neg);

% Create a big matrix by concatenating the matrices side to side
pos_train = [pos_train_cloudy pos_train_foggy pos_train_rainy pos_train_snowy pos_train_sunny];
neg_train = [neg_train_cloudy neg_train_foggy neg_train_rainy neg_train_snowy neg_train_sunny];
pos_test = [pos_test_cloudy pos_test_foggy pos_test_rainy pos_test_snowy pos_test_sunny];
neg_test = [neg_test_cloudy neg_test_foggy neg_test_rainy neg_test_snowy neg_test_sunny];

% Make permutation on the matrices
pos_train = pos_train(:,randperm(size(pos_train, 2)));
neg_train = neg_train(:,randperm(size(neg_train, 2)));
pos_test = pos_test(:,randperm(size(pos_test, 2)));
neg_test = neg_test(:,randperm(size(neg_test, 2)));

% Separate the rows from the last one, in order of getting 
% both the data and the labels
data_pos_train = pos_train(1:number_features(curr_model),:);
labels_pos_train = pos_train(number_features(curr_model)+1,:);

data_neg_train = neg_train(1:number_features(curr_model),:);
labels_neg_train = neg_train(number_features(curr_model)+1,:);

data_pos_test = pos_test(1:number_features(curr_model),:);
labels_pos_test = pos_test(number_features(curr_model)+1,:);

data_neg_test = neg_test(1:number_features(curr_model),:);
labels_neg_test = neg_test(number_features(curr_model)+1,:);
%}

% Separate the rows from the last one, in order of getting 
% both the data and the labels
data_pos_train = pos_train_cloudy(1:number_features(curr_model),:);
labels_pos_train = pos_train_cloudy(number_features(curr_model)+1,:);

data_neg_train = neg_train_cloudy(1:number_features(curr_model),:);
labels_neg_train = neg_train_cloudy(number_features(curr_model)+1,:);

data_pos_test = pos_test_cloudy(1:number_features(curr_model),:);
labels_pos_test = pos_test_cloudy(number_features(curr_model)+1,:);

data_neg_test = neg_test_cloudy(1:number_features(curr_model),:);
labels_neg_test = neg_test_cloudy(number_features(curr_model)+1,:);

data_train = [data_pos_train data_neg_train];
labels_train = [labels_pos_train labels_neg_train];

data_test = [data_pos_test data_neg_test];
labels_test = [labels_pos_test labels_neg_test];
% --------------------------------------------------------------------
% Stage B: Training a classifier
% --------------------------------------------------------------------

% Train the linear SVM. The SVM paramter C should be
% cross-validated. Here for simplicity we pick a valute that works
% well with all kernels.
[train_w, train_bias] = trainLinearSVM(data_train, labels_train, C) ;

% Evaluate the scores on the training data
train_scores = w' * data_train + bias ;

% Visualize the ranked list of images
%figure(1) ; clf ; set(1,'name','Ranked training images (subset)') ;
%displayRankedImageList(names, scores)  ;

% Visualize the precision-recall curve
%figure(2) ; clf ; set(2,'name','Precision-recall on train data') ;
%vl_pr(labels, scores) ;

% --------------------------------------------------------------------
% Stage C: Classify the test images and assess the performance
% --------------------------------------------------------------------

% Test the linear SVM
test_scores = w' * data_test + bias ;

% Visualize the ranked list of images
%figure(3) ; clf ; set(3,'name','Ranked test images (subset)') ;
%displayRankedImageList(testNames, testScores)  ;

% Visualize visual words by relevance on the first image
% [~,best] = max(testScores) ;
% displayRelevantVisualWords(testNames{best},w)

% Visualize the precision-recall curve
figure(4) ; clf ; set(4,'name','Precision-recall on test data') ;
vl_pr(labels_test, test_scores) ;

% Print results
[drop,drop,info] = vl_pr(labels_test, test_scores) ;
fprintf('Test AP: %.2f\n', info.auc) ;

[drop,perm] = sort(test_scores,'descend') ;
fprintf('Correctly retrieved in the top 36: %d\n', sum(labels_test(perm(1:36)) > 0)) ;
end
