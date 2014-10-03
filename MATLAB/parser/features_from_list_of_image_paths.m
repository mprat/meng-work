% [list_of_filenames, labels] = utils.mat_to_cell_array('../../vids_to_download/vid_names_and_frames_and_labels_10_2.mat');
% list_of_filenames = {'~/ed-vids/M-600X-FA12-L6-2v2_100/image_00000100.png', '~/ed-vids/M-600X-FA12-L6-2v2_100/image_00000402.png', '~/ed-vids/M-600X-FA12-L6-Intro_100/image_00000002.png', '~/ed-vids/M-600X-FA12-L6-Intro_100/image_00000002.png'}

function features = features_from_list_of_image_paths(list_image_paths, place_to_save_features)
	% list_trans = list_image_paths';

	% nImgs = 256
	% imageList_small = list_trans(1:256,1);

	disp('start extract deep features');
	[features, scoreSet] = extractDeepFeatures(list_image_paths); % the input is image path, the number of images should be no smaller than 256 (you could duplicate one image to 256)
	save(place_to_save_features, 'features');

end