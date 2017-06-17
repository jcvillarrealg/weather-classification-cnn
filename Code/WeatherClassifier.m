%Adding path to the features
addpath('/Users/JoseCarlosVillarreal/Documents/DissertationDevelopment/weather-classification-cnn/features/');

%%IMPORTANT VARIABLES TO CHANGES ON EACH RUN
model = 'bvlc_googlenet';
category = [string('cloudy'), string('foggy'), string('rainy'), string('snowy'), string('sunny')];

%Loading data
%pos_train, neg_train, pos_test, neg_test

%Cloudy Category
pos_train_cloudy = load(['../features/' model '/' char(category(1)) '/_positive_train_features.mat']) ;
neg_train_cloudy = load(['../features/' model '/' char(category(1)) '/_negative_train_features.mat']) ;
pos_test_cloudy = load(['../features/' model '/' char(category(1)) '/_positive_test_features.mat']) ;
neg_test_cloudy = load(['../features/' model '/' char(category(1)) '/_negative_test_features.mat']) ;

pos_train_cloudy = pos_train_cloudy.code ;
neg_train_cloudy = neg_train_cloudy.code_neg ;
pos_test_cloudy = pos_test_cloudy.code_v ;
neg_test_cloudy = neg_test_cloudy.code_v_neg ;

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

%


% Concatenar las labels a cada columna

% Una vez que se tienen todas las categorias, concatenar horizontalmente y
% hacer permutacion aleatoria

%Separar los renglones del ultimo renglon para tener datos y labels por
%separado y listos para el paso 2: classifier

% --------------------------------------------------------------------
% Stage B: Training a classifier
% --------------------------------------------------------------------

% Train the linear SVM. The SVM paramter C should be
% cross-validated. Here for simplicity we pick a valute that works
% well with all kernels.
C = 10 ;
[w, bias] = trainLinearSVM(histograms, labels, C) ;
disp('Histograms')
disp(histograms(1:5,1:5))
disp('labels')
disp(labels(115:130))

% Evaluate the scores on the training data
scores = w' * histograms + bias ;

% Visualize the ranked list of images
figure(1) ; clf ; set(1,'name','Ranked training images (subset)') ;
displayRankedImageList(names, scores)  ;

% Visualize the precision-recall curve
figure(2) ; clf ; set(2,'name','Precision-recall on train data') ;
vl_pr(labels, scores) ;

% --------------------------------------------------------------------
% Stage C: Classify the test images and assess the performance
% --------------------------------------------------------------------

% Test the linear SVM
testScores = w' * testHistograms + bias ;

% Visualize the ranked list of images
figure(3) ; clf ; set(3,'name','Ranked test images (subset)') ;
displayRankedImageList(testNames, testScores)  ;

% Visualize visual words by relevance on the first image
% [~,best] = max(testScores) ;
% displayRelevantVisualWords(testNames{best},w)

% Visualize the precision-recall curve
figure(4) ; clf ; set(4,'name','Precision-recall on test data') ;
vl_pr(testLabels, testScores) ;

% Print results
[drop,drop,info] = vl_pr(testLabels, testScores) ;
fprintf('Test AP: %.2f\n', info.auc) ;

[drop,perm] = sort(testScores,'descend') ;
fprintf('Correctly retrieved in the top 36: %d\n', sum(testLabels(perm(1:36)) > 0)) ;
