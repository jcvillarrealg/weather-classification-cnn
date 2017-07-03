function [complete_data, complete_labels] = weatherclassification_nn(initialdirectory, model, numberfeatures)
%initialdirectory = '../extractedFeatures/';
%model = 'bvlc_googlenet';

% Getting the data extracted by the chosen model

cloudy_train_googlenet = load([initialdirectory model '/cloudy/positive_train_features.mat']);
cloudy_train_googlenet = cloudy_train_googlenet.code;
cloudy_test_googlenet = load([initialdirectory model '/cloudy/positive_test_features.mat']);
cloudy_test_googlenet = cloudy_test_googlenet.code_v;

foggy_train_googlenet = load([initialdirectory model '/foggy/positive_train_features.mat']);
foggy_train_googlenet = foggy_train_googlenet.code;
foggy_test_googlenet = load([initialdirectory model '/foggy/positive_test_features.mat']);
foggy_test_googlenet = foggy_test_googlenet.code_v;

rainy_train_googlenet = load([initialdirectory model '/rainy/positive_train_features.mat']);
rainy_train_googlenet = rainy_train_googlenet.code;
rainy_test_googlenet = load([initialdirectory model '/rainy/positive_test_features.mat']);
rainy_test_googlenet = rainy_test_googlenet.code_v;

snowy_train_googlenet = load([initialdirectory model '/snowy/positive_train_features.mat']);
snowy_train_googlenet = snowy_train_googlenet.code;
snowy_test_googlenet = load([initialdirectory model '/snowy/positive_test_features.mat']);
snowy_test_googlenet = snowy_test_googlenet.code_v;

sunny_train_googlenet = load([initialdirectory model '/sunny/positive_train_features.mat']);
sunny_train_googlenet = sunny_train_googlenet.code;
sunny_test_googlenet = load([initialdirectory model '/sunny/positive_test_features.mat']);
sunny_test_googlenet = sunny_test_googlenet.code_v;

%Joining all the data

cloudy_data = [cloudy_train_googlenet cloudy_test_googlenet];
foggy_data = [foggy_train_googlenet foggy_test_googlenet];
rainy_data = [rainy_train_googlenet rainy_test_googlenet];
snowy_data = [snowy_train_googlenet snowy_test_googlenet];
sunny_data = [sunny_train_googlenet sunny_test_googlenet];

%Add the labes to the data
cloudy_labels = 1 * ones(1, size(cloudy_data,2));
foggy_labels = 2 * ones(1, size(foggy_data,2));
rainy_labels = 3 * ones(1, size(rainy_data,2));
snowy_labels = 4 * ones(1, size(snowy_data,2));
sunny_labels = 5 * ones(1, size(sunny_data,2));

cloudy_data = vertcat(cloudy_data, cloudy_labels);
foggy_data = vertcat(foggy_data, foggy_labels);
rainy_data = vertcat(rainy_data, rainy_labels);
snowy_data = vertcat(snowy_data, snowy_labels);
sunny_data = vertcat(sunny_data, sunny_labels);

%Joining all the data
data_and_labels = [cloudy_data foggy_data rainy_data snowy_data sunny_data];
data_and_labels = data_and_labels(:, randperm(size(data_and_labels, 2)));

clear cloudy_data foggy_data rainy_data snowy_data sunny_data

%Getting the data and labels separated
complete_data = data_and_labels(1:numberfeatures, :);
complete_labels = data_and_labels(numberfeatures + 1, :);

end
