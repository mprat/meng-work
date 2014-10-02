load('model-288-training-samples.mat');

% need very much to make sure you change the names of the predictor arguments and the like.
load('256-from-ID-EMaTF9-ArJY.mat');
features = featureSet;
l = zeros(256, 1);

[predicted_label, accuracy, decision_values] = libsvm.svmpredict(l, features, model)

% for i=1:length(predicted_label):