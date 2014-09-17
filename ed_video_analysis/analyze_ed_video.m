clear;
restoredefaultpath;
addpath(genpath('~/Dropbox/MEng/edx-vids/'));
addpath(genpath('~/Dropbox/MEng/cache/'));

datadir  = '~/Dropbox/MEng/edx-vids/';
cachedir = '~/Dropbox/MEng/cache/';
vid_name = 'M-3091X-FA12-L1-3_100-10_secs';
vid_storage_path = [cachedir vid_name '/'];
mkdir(vid_storage_path);
vid_path = [datadir vid_name '/'];
body_tracked_img_dir = [vid_storage_path '/body_tracked/'];
mkdir(body_tracked_img_dir);


dres_fname = [vid_storage_path vid_name '_detec_res.mat'];
bboxes_fname = [vid_storage_path vid_name '_bboxes.mat'];


imlist=dir([vid_path '/*.png']);

max_imgs = 4; % for ALL, just do length(imlist)

try
    disp('Using BUFFY model');
    load('BUFFY_final');
    load(bboxes_fname)
    load(dres_fname)
%     addpath(genpath('pose-release-ver1.2'));
%     rmpath(genpath('pose-release-ver1.2'));
    [bboxes, dres] = find_boxes(vid_name, length(bboxes) + 1, max_imgs, model, bboxes_fname, bboxes, dres_fname);
catch
    disp('You have never analyzed this video before');
    [bboxes, dres] = find_boxes(vid_name, 1, max_imgs);
end


% addpath(genpath('tracking_cvpr11_release_v1.0'));

%%% setting parameters for tracking
c_en      = 10;     %% birth cost
c_ex      = 10;     %% death cost
c_ij      = 0;      %% transition cost
betta     = 0.2;    %% betta
max_it    = inf;    %% max number of iterations (max number of tracks)
thr_cost  = 18;     %% max acceptable cost for a track (increase it to have more tracks.)

%%% Running tracking algorithms
display('in DP tracking ...')
tic
dres_dp       = tracking_dp(dres, c_en, c_ex, c_ij, betta, thr_cost, max_it, 0);
dres_dp.r     = -dres_dp.id;
toc

input_frames    = [datadir vid_name '/image_%0.8d_0.png'];
output_path     = [vid_storage_path vid_name '_dp_tracked/'];
output_vidname  = [vid_storage_path vid_name '_dp_tracked.avi'];

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



