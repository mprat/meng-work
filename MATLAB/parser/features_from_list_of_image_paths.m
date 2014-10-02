% [list_of_filenames, labels] = utils.mat_to_cell_array('../../vids_to_download/vid_names_and_frames_and_labels_10_2.mat');
% list_of_filenames = {'~/ed-vids/M-600X-FA12-L6-2v2_100/image_00000100.png', '~/ed-vids/M-600X-FA12-L6-2v2_100/image_00000402.png', '~/ed-vids/M-600X-FA12-L6-Intro_100/image_00000002.png', '~/ed-vids/M-600X-FA12-L6-Intro_100/image_00000002.png'}

list_of_filenames = {256, 1};


max_framenum = 256;
for i=1:max_framenum
	list_of_filenames(i) = cellstr(sprintf('~/ed-vids/ID-EMaTF9-ArJY/image_%08d.png', i));
end


% list_of_filenames = repmat(list_of_filenames, 1, 64);
% labels = repmat(labels, 4, 1)
list_trans = list_of_filenames';

% nImgs = 256
% imageList_small = list_trans(1:256,1);

disp('start extract deep features');
[featureSet, scoreSet] = extractDeepFeatures(list_trans); % the input is image path, the number of images should be no smaller than 256 (you could duplicate one image to 256)

save('256-from-ID-EMaTF9-ArJY.mat');
% save('256-from-4-test-images.mat', 'featureSet');
% save('288-from-training-data-4-times-with-labels.mat', 'featureSet');%, 'labels');

% 
% for i=1:nImgs
%    disp(list_of_filenames) 
% end

% nImgs = numel(imlist); % sounds like there should be a minimum of 256
% imageList = cell(nImgs,1);
% for i=1:nImgs
%     imageList{i} = [imgData_path '/' imlist(i).name];
% end