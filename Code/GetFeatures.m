clear
%set models and categories
models1 = [string('bvlc_googlenet')];
models2 = [string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];
models = models1;
%models = [string('bvlc_googlenet'),string('ResNet50')];
disp('[LOG] Created models array')
categories = [string('cloudy'),string('foggy'),string('rainy'),string('snowy'),string('sunny')];
%categories = [string('cloudy'),string('foggy')];
disp('[LOG] Created categories array')
% set the directory to store the results

features_base_dir = '../../../DissertationDevelopment/weather-classification-cnn/features/';
disp('[LOG] Pointing to directory:')
disp(features_base_dir)
% Make calls to each possible combination of models
disp('[LOG] Starting Feature Extraction')
for i = (1:1:length(models))
    disp(fprintf('[LOG] Model %s \n', models(i)))
    for j = (1:1:length(categories))
        disp(fprintf('[LOG] Category %s \n', categories(j)))
        %For each model and each of its categories, extract features and
        %save them to a file
        current_dir = string(features_base_dir) + string(sprintf('%s/%s/', models(i), categories(j)));
        disp(current_dir)
        [code, code_v, code_neg, code_v_neg] = matdeeprep(char(models(i)), 'ExtendedWeatherDatabase_SP', char(categories(j)));
        
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