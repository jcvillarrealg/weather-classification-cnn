% Classifier in batches

addpath('/Users/JoseCarlosVillarreal/Documents/practical-category-recognition-2015a');
% Define models and classifiers available
models = [string('bvlc_googlenet'),string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];
categories = [string('cloudy'), string('foggy'), string('rainy'), string('snowy'), string('sunny')];
images_type = 'superpixel';
C = 10 ;


% For each model 
for i = (1:1:length(models))
    disp('i')
    disp(i)
    disp(fprintf('[LOG] Model %s \n', models(i)))
% For each category
    for j = (1:1:length(categories))
        disp('j')
        disp(j)
        disp(fprintf('[LOG] Category %s \n', categories(j)))
% Train the classifier, getting is results as output
    % Average Precision is in the info.auc struct
        base_dir = sprintf('../results_superpixels/%s/%s/', models(i), categories(j));
        [train_w,train_bias,train_scores,test_scores,info]=WeatherClassifier_TwoClass(models(i), categories(j), images_type, C);
        disp(sprintf('Model %s for category %s has AP of %s', model, category, info.auc))
        save([base_dir 'results.mat'],'train_w','train_bias','train_scores','test_scores','info');
        clear train_w train_bias test_w test_bias train_scores test_scores info;
  % Save results to a file
    end
end