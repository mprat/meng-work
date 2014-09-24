% this loads the SUN categories. I assume this is not needed
% load('SUN397category.mat');

%% load images
% change this depending on where the images are going to live
vid_name = 'H-PH207X-FA12-L1-10_100-NWe1Hnwr6OM';
imgData_path = ['/afs/csail.mit.edu/u/m/mprat/ed-vids/' vid_name];
metaData_path = '/afs/csail.mit.edu/u/m/mprat/ed-vids/';

% curCity = 'boston';
% curMetaData = load([metaData_path 'gps_' curCity '.mat']);
% curGPS = curMetaData.gps(:,3:4); % GPS location of the images
% nImgs = numel(curMetaData.images);

%% TODO: programmatically find the number of images somehow. 
% The size of the directory, or a list of their names in a cell array
% or something else. Probably some peripheral data structure
imlist = dir([imgData_path '/*.png']);
nImgs = numel(imlist); % sounds like there should be a minimum of 256
imageList = cell(nImgs,1);
for i=1:nImgs
    imageList{i} = [imgData_path '/' imlist(i).name];
end
% imageList = imageList(randperm(numel(imageList)),1);
% 
imageList_small = imageList(1:256,1);

%% compute the deep features for the images.

disp('start extract deep features');
featureSet = extractDeepFeatures(imageList_small); % the input is image path, the number of images should be no smaller than 256 (you could duplicate one image to 256)


%% draw the detected features on each image
for i=1:numel(imageList_small)
	curImg = imread(imageList_small{i});
	imshow(curImg)
	waitforbuttonpress
end


% featureSet is the feature matrix for each image and scoreSet is the predicted probabilities for scene categories 
% figure
% for i=1:numel(imageList_small)
%     curImg = imread(imageList_small{i});
%     [~,IDX] = sort(scoreSet(i,:),'descend');
%     disp(categories(IDX(1:10)))
%     imshow(curImg)
%     waitforbuttonpress
% end