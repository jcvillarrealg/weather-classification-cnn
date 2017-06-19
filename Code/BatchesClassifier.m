% Classifier in batches

% Define models and classifiers available
models = [string('bvlc_googlenet'),string('placesCNN'),string('ResNet50'),string('ResNet101'),string('ResNet152'),string('VGG_CNN_F'),string('VGG_CNN_M'),string('VGG_CNN_S'),string('VGGNet16'),string('VGGNet19') ];
categories = [string('cloudy'), string('foggy'), string('rainy'), string('snowy'), string('sunny')];
image_type = 'superpixels';
C = 10 ;


%To use superpixel images uncomment the following line and comment out the
%previous line
%image_type = 'superpixel';

% For each model 
for i = (1:1:length(models))
    disp(fprintf('[LOG] Model %s \n', models(i)))
% For each category
    for j = (1:1:length(categories))
        disp(fprintf('[LOG] Category %s \n', categories(i)))
% Train the classifier, getting is results as output
    % Average Precision is in the info.auc struct
        base_dir = fprint('..results/%s/%s/', models(i), categories(i));
        [train_w,train_bias,test_w,test_bias,train_scores,test_scores,info]=WeatherClassifier_TwoClass(models(i), categories(j), images_type, C);
        disp(fprintf('Model %s for category %s has AP of %s', model, category, info.auc))
        save([base_dir 'results.mat'],'train_w','train_bias','test_w','test_bias','train_scores','test_scores','info');
        clear train_w train_bias test_w test_bias train_scores test_scores info;
  % Save results to a file
    end
end