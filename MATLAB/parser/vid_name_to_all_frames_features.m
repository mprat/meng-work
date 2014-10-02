% get list of filenames

vid_name = 'ID-aTuYZqhEvuk';
max_framenum = 256;

list_of_filenames = {max_framenum, 1};
for i=1:max_framenum
	list_of_filenames(i) = cellstr(sprintf('~/ed-vids/%s/image_%08d.png', vid_name, i));
end

list_trans = list_of_filenames';

disp('start extract deep features');
[featureSet, scoreSet] = extractDeepFeatures(list_trans); % the input is image path, the number of images should be no smaller than 256 (you could duplicate one image to 256)

save(sprintf('256-from-%s.mat', vid_name), 'featureSet');

% use svm predict
load('model-288-training-samples.mat');
load(sprintf('256-from-%s.mat', vid_name));


features = featureSet;
l = zeros(max_framenum, 1);

[predicted_label_num, accuracy, decision_values] = libsvm.svmpredict(l, features, model)

predicted_label_text = cell(length(predicted_label_num), 1);

idx_to_label = {'head', 'slide', 'lecture'};

for i=1:length(predicted_label_num)
	predicted_label_text(i) = idx_to_label(predicted_label_num(i));
end

save(sprintf('256-from-%s-predicted-labels.mat', vid_name), 'predicted_label_text', 'predicted_label_num');