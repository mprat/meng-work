clear;
% load('model-288-training-samples.mat');
load('256-from-ID-EMaTF9-ArJY.mat');
load('model-3-class-all-training-10-2-samples.mat');

[predicted_label_num, accuracy, decision_values] = libsvm.svmpredict(test_labels_truth, test_features, model);

predicted_label_text = cell(length(predicted_label_num), 1);

idx_to_label = {'head', 'slide', 'lecture'};

for i=1:length(predicted_label_num)
	predicted_label_text(i) = idx_to_label(predicted_label_num(i));
end

save('256-from-ID-EMaTF9-ArJY-predicted-labels-model-3-class-all-training-10-2-samples.mat', 'predicted_label_text', 'predicted_label_num');