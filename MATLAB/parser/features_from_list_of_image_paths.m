list_of_filenames = utils.mat_to_cell_array('../../vids_to_download/vid_names_and_frames_9_30_all.mat');
list_of_filenames = repmat(list_of_filenames, 1, 4);
list_trans = list_of_filenames';

% nImgs = 256
% imageList_small = list_trans(1:256,1);

disp('start extract deep features');
[featureSet, scoreSet] = extractDeepFeatures(list_trans); % the input is image path, the number of images should be no smaller than 256 (you could duplicate one image to 256)

% 
% for i=1:nImgs
%    disp(list_of_filenames) 
% end

% nImgs = numel(imlist); % sounds like there should be a minimum of 256
% imageList = cell(nImgs,1);
% for i=1:nImgs
%     imageList{i} = [imgData_path '/' imlist(i).name];
% end