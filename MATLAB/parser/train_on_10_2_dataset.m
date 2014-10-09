clear;
[image_paths, labels] = utils.mat_to_cell_array('../../vids_to_download/vid_names_and_frames_and_labels-training-set-10-2.mat');

labels = str2double(labels);
% labels(labels==3) = 2; % turns all 3 labels (lecture) into 2, which then means it becomes head vs not head

% only select 22 of 1 and 22 of 2
% num_each = 22;
% final_image_paths = cell(256, 1);
% final_labels = zeros(44, 1);
% one_count = 0;
% two_count = 0;
% index = 1;
% for i=1:length(labels)
% 	if labels(iimage_pa) == 1 & one_count < num_each
% 		final_image_paths(index) = image_paths(i);
% 		final_labels(index) = labels(i);
% 		index = index + 1;
% 		one_count = one_count + 1;
% 	elseif labels(i) == 2 & two_count < num_each
% 		final_image_paths(index) = image_paths(i);
% 		final_labels(index) = labels(i);
% 		index = index + 1;
% 		two_count = two_count + 1;
% 	end
% end

% ix = cellfun('isempty', final_image_paths);
% final_image_paths(ix) = final_image_paths(1);

% final_image_paths = repmat()

image_paths_to_get_features = repmat(image_paths, 1, 3); % need at least 256 images to get features
image_paths_to_get_features = image_paths_to_get_features';
% load('44-features-training-set-9-30.mat');

features = features_from_list_of_image_paths(image_paths_to_get_features, 'training-set-10-2.mat');

%% don't scale features
training_features = features(1:length(image_paths), :);;
training_labels = labels';
model = libsvm.svmtrain(training_labels, training_features)

%% scale features
% f_scaled = zeros(256, 4096);
% f_max = max(features);
% f_max(isnan(f_max)) = 1;
% f_max(f_max==0) = 1;
% for i=1:length(features(:, 1))
% 	f_scaled(i, :) = features(i, :) ./ f_max;
% end
% model = libsvm.svmtrain(final_labels, f_scaled(1:44, :))
% training_features = f_scaled(1:44, :);
% training_labels = final_labels;

save('model-3-class-all-training-10-2-samples.mat', 'model', 'training_features', 'training_labels');