clear;
restoredefaultpath;
addpath(genpath('~/Dropbox/MEng/edx-vids/'));
addpath(genpath('~/Dropbox/MEng/cache/'));

datadir  = '~/Dropbox/MEng/edx-vids/';
cachedir = '~/Dropbox/MEng/cache/';
mkdir(cachedir);
vid_name = 'M-3091X-FA12-L1-3_100-4_secs';
vid_path = [datadir vid_name '/'];

body_tracked_img_dir = [cachedir vid_name '/body_tracked/'];
mkdir(body_tracked_img_dir);

% stuff from pose
addpath(genpath('pose-release-ver1.2/'));
disp('BUFFY model');
% load and display model
load('BUFFY_final');
% TODO: change to only load the models, not see them
% visualizemodel(model);
% disp('model template visualization');
% disp('press any key to continue'); 
% pause;
% visualizeskeleton(model);
% disp('model tree visualization');
% disp('press any key to continue'); 
% pause;

imlist=dir([vid_path '/*.png']);
fname = [cachedir vid_name '_detec_res.mat'];
bboxes_fname = [cachedir vid_name '_bboxes.mat'];
num_images_to_process = 4;
try
    load(fname)
catch
%     parpool;
    
    for i=1:num_images_to_process;
        display(['frame ' num2str(i)])
        tic;
        im = imread([vid_path imlist(i).name]);
%         clf; imagesc(im); axis image; axis off; drawnow;
        boxes = detect(im, model, min(model.thresh,-1));
        boxes = nms(boxes, .1); % nonmaximal suppression
%         fprintf('detection took %.1f seconds\n',toc);
        
        %colorset = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
        %im = showboxes(im, boxes(1,:),colorset); % show the best detection
        %f = getframe(gca);
        %im = frame2im(f);
        %imwrite(im,[body_tracked_img_dir '/image_body_tracked_' sprintf('%0.8d', i) '.png']);
        
        bboxes(i).bbox = boxes(1,:);

        % image(im);
        %showboxes(im, boxes,colorset);  % show all detections

        fprintf('detection took %.1f seconds\n',toc);
        % TODO - save image with lines written on it
%         disp('press enter to go to next frame');
%         pause;
    end
    
    rmpath(genpath('pose-release-ver1.2/'));
    addpath(genpath('tracking_cvpr11_release_v1.0'));
    dres = bboxes2dres(bboxes);
    dres = build_graph(dres);
    save(fname, 'dres');
    save(bboxes_fname, 'bboxes');
    
%     delete(gcp);
end

rmpath(genpath('pose-release-ver1.2/'));
addpath(genpath('tracking_cvpr11_release_v1.0'));

%%% setting parameters for tracking
c_en      = 10;     %% birth cost
c_ex      = 10;     %% death cost
c_ij      = 0;      %% transition cost
betta     = 0.2;    %% betta
max_it    = inf;    %% max number of iterations (max number of tracks)
thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)

%%% Running tracking algorithms
%%% Need to figure out which of these is the "better" one for our purposes
display('in DP tracking ...')
tic
dres_dp       = tracking_dp(dres, c_en, c_ex, c_ij, betta, thr_cost, max_it, 0);
dres_dp.r     = -dres_dp.id;
toc

input_frames    = [datadir vid_name '/image_%0.8d_0.png'];
output_path     = [cachedir vid_name '_dp_tracked/'];
output_vidname  = [cachedir vid_name '_dp_tracked.avi'];

display(output_vidname)
fnum = max(dres.fr);
bboxes_tracked = dres2bboxes(dres_dp, fnum);

%necessary in macosx for ffmpeg
%(http://www.mathworks.com/matlabcentral/answers/32062-error-runing-ffmpeg-in-matlab-function-in-linux)
setenv('PATH', [getenv('PATH') ':/usr/local/bin'])

% load label file
load('tracking_cvpr11_release_v1.0/data/label_image_file');
m=2;
for i=1:length(bws)                   %% adds some margin to the label images
  [sz1 sz2] = size(bws(i).bw);
  bws(i).bw = [zeros(sz1+2*m,m) [zeros(m,sz2); bws(i).bw; zeros(m,sz2)] zeros(sz1+2*m,m)];
end
show_bboxes_on_video(input_frames, bboxes_tracked, output_vidname, bws, 4, -inf, output_path);

rmpath(genpath('tracking_cvpr11_release_v1.0'));


% display all the best-detected bounding boxes into files and save them
addpath(genpath('pose-release-ver1.2/'));
load(bboxes_fname);
for i=1:num_images_to_process
    im = imread([vid_path imlist(i).name]);
    clf; imagesc(im); axis image; axis off; drawnow;
    colorset = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
    showboxes(im, bboxes(i).bbox,colorset); % show the best detection
    f = getframe(gca);
    im = frame2im(f);
    imwrite(im,[body_tracked_img_dir '/image_body_tracked_' sprintf('%0.8d', i) '.png']);
end
rmpath(genpath('pose-release-ver1.2/'));
        