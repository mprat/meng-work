% load('model-288-training-samples.mat');
load('256-from-ID-EMaTF9-ArJY.mat');
load('model-heads-vs-no-heads-22-each-scaled-training-9-30-samples.mat')


features = featureSet;
l = zeros(256, 1);

[predicted_label_num, accuracy, decision_values] = libsvm.svmpredict(l, features, model);

predicted_label_text = cell(length(predicted_label_num), 1);

idx_to_label = {'head', 'slide', 'lecture'};

for i=1:length(predicted_label_num)
	predicted_label_text(i) = idx_to_label(predicted_label_num(i));
end

save('256-from-ID-EMaTF9-ArJY-predicted-labels-heads-vs-no-heads-22-each-training-9-30.mat', 'predicted_label_text', 'predicted_label_num');