% load feature list and label list

load('288-from-training-set-4-times-with-labels.mat');
labels = str2num(labels);
model = libsvm.svmtrain(labels, featureSet)

training_features = featureSet;
training_labels = labels;

save('model-288-training-samples.mat', 'model', 'training_features', 'training_labels');