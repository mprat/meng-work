[image_paths, labels] = utils.mat_to_cell_array('../../vids_to_download/vid_names_and_frames_and_labels-training-set-9-30.mat');

% change all '3' labels to '2' (effectively make this dataset 'head' and 'not head')

labels = str2num(labels);
labels(labels==3) = 2;

% only select 22 of 1 and 22 of 2
num_each = 22;
final_image_paths = cell(256, 1);
final_labels = zeros(44, 1);

one_count = 0;
two_count = 0;
index = 1;

for i=1:length(labels)
	if labels(i) == 1 & one_count < num_each
		final_image_paths(index) = image_paths(i);
		final_labels(index) = labels(i);
		index = index + 1;
		one_count = one_count + 1;
	elseif labels(i) == 2 & two_count < num_each
		final_image_paths(index) = image_paths(i);
		final_labels(index) = labels(i);
		index = index + 1;
		two_count = two_count + 1;
	end
end

ix = cellfun('isempty', final_image_paths);
final_image_paths(ix) = final_image_paths(1);

% final_image_paths = repmat()

features = features_from_list_of_image_paths(final_image_paths', '44-features-training-set-9-30.mat');

% scale features
f_scaled = zeros(256, 4096);
f_max = max(features);

for i=1:length(features(:, 1))
	f_scaled(i, :) = features(i, :) ./ f_max;
end

model = libsvm.svmtrain(final_labels, f_scaled(1:44, :))

training_features = f_scaled(1:44, :);
training_labels = final_labels;

save('model-heads-vs-no-heads-22-each-training-9-30-samples.mat', 'model', 'training_features', 'training_labels');