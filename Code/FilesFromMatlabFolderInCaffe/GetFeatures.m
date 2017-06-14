clear
%set models and categories

models = [string('bvlc_alexnet'),string('bvlc_googlenet'),string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];

categories = [string('cloudy'),string('foggy'),string('rainy'),string('snowy'),string('sunny')];

% set the directory to store the results

features_base_dir = '../../../DissertationDevelopment/weather-classification-cnn/features/';

% Make calls to each possible combination of models

for i = (1:1:length(models))
    for j = (1:1:length(categories))
        %For each model and each of its categories, extract features and
        %save them to a file
        current_dir = string(features_base_dir) + string(sprintf('%s/%s', models(i), categories(j)));
        [code, code_v, code_neg, code_v_neg] = matdeeprep(char(models(i)), 'ExtendedWeatherDatabase', char(categories(j)));
        
        save(char(current_dir + string('positive_train_features.mat')), code);
        save(char(current_dir + string('positive_test_features.mat')), code_v);
        save(char(current_dir + string('negative_train_features.mat')), code_neg);
        save(char(current_dir + string('negative_test_features.mat')), code_v_neg);
        
    end
end