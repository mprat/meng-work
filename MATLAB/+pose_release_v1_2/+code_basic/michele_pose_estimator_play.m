compile;

disp('PARSE model');
% load and display model
load('PARSE_final');
visualizemodel(model);
disp('model template visualization');
disp('press any key to continue'); 
pause;
visualizeskeleton(model);
disp('model tree visualization');
disp('press any key to continue'); 
pause;

im_dir_prefix = '~/Dropbox/MEng/edx-vids/M-3091X-FA12-L1-3_100-10_secs/';
% imlist = dir('images/*.png');
imlist=dir([im_dir_prefix '/*.png']);

im = imread([im_dir_prefix imlist(1).name]);
clf; imagesc(im); axis image; axis off; drawnow;

% call detect function
tic;
boxes = detect(im, model, min(model.thresh,-1));
boxes = nms(boxes, .1); % nonmaximal suppression
colorset = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
showboxes(im, boxes(1,:),colorset); % show the best detection
%showboxes(im, boxes,colorset);  % show all detections

fprintf('detection took %.1f seconds\n',toc);
disp('press any key to continue');
pause;


disp('BUFFY model');
% load and display model
load('BUFFY_final');
visualizemodel(model);
disp('model template visualization');
disp('press any key to continue'); 
pause;
visualizeskeleton(model);
disp('model tree visualization');
disp('press any key to continue'); 
pause;


im = imread([im_dir_prefix imlist(1).name]);
clf; imagesc(im); axis image; axis off; drawnow;

% call detect function
tic;
boxes = detect(im, model, min(model.thresh,-1));
dettime = toc; % record cpu time
boxes = nms(boxes, .1); % nonmaximal suppression
colorset = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
showboxes(im, boxes(1,:),colorset); % show the best detection
%showboxes(im, boxes,colorset);  % show all detections

fprintf('detection took %.1f seconds\n',toc);
disp('press any key to continue');
pause;



disp('done');
