function vid_name_to_all_frames_features(vid_name)
	% vid_name is the name of the video, of the form 'ID-EMaTF9-ArJY'

	max_framenum = length(dir(['~/ed-vids/' vid_name '/image*.png'])); % only count the .png files

	list_of_filenames = {max_framenum, 1};
	for i=1:max_framenum
		list_of_filenames(i) = cellstr(sprintf('~/ed-vids/%s/image_%08d.png', vid_name, i));
	end

	list_trans = list_of_filenames';

	disp('start extract deep features');
	[featureSet, scoreSet] = extractDeepFeatures(list_trans); % the input is image path, the number of images should be no smaller than 256 (you could duplicate one image to 256)

	save(sprintf('%d-from-%s.mat', max_framenum, vid_name), 'featureSet');

	% use svm predict
	load('model-3-class-all-training-10-2-samples.mat');
	load(sprintf('%d-from-%s.mat', max_framenum, vid_name));


	features = featureSet;
	l = zeros(max_framenum, 1);

	[predicted_label_num, accuracy, decision_values] = libsvm.svmpredict(l, features, model);

	predicted_label_text = cell(length(predicted_label_num), 1);

	idx_to_label = {'head', 'slide', 'lecture'};

	for i=1:length(predicted_label_num)
		predicted_label_text(i) = idx_to_label(predicted_label_num(i));
	end

	save(sprintf('%d-from-%s-predicted-labels.mat', max_framenum, vid_name), 'predicted_label_text', 'predicted_label_num');
end