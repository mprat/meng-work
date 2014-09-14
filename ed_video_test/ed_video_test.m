clear

% cd ('tracking_cvpr11_release_v1.0/3rd_party/voc-release3.1')
% compile                                         %% compiling mex files for part-based object detector
% cd('../..');

addpath(genpath('tracking-release-v1.0'));
addpath('pose-release-v1.2');
addpath('standard-datasets');

datadir  = '~/Dropbox/MEng/edx-vids/';
cachedir = '~/Dropbox/MEng/cache/';
mkdir(cachedir);
vid_name = 'M-3091X-FA12-L1-3_100-4_secs';
vid_path = [datadir vid_name '/'];

%%% Run object/human detector on all frames.
display('in object/human detection... (may take an hour using 8 CPU cores: please set the number of available CPU cores in the code)')
fname = [cachedir vid_name '_detec_res.mat'];
try
  load(fname)
catch
  [dres, bboxes] = detect_objects(vid_path);
  save (fname, 'dres', 'bboxes');
end

%%% Adding transition links to the graph by fiding overlapping detections in consequent frames.
display('in building the graph...')
fname = [cachedir vid_name '_graph_res.mat'];
try
  load(fname)
catch
  dres = build_graph(dres);
  save (fname, 'dres');
end

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

tic
display('in DP tracking with nms in the loop...')
dres_dp_nms   = tracking_dp(dres, c_en, c_ex, c_ij, betta, thr_cost, max_it, 1);
dres_dp_nms.r = -dres_dp_nms.id;
toc

% tic
% display('in push relabel algorithm ...')
% dres_push_relabel   = tracking_push_relabel(dres, c_en, c_ex, c_ij, betta, max_it);
% dres_push_relabel.r = -dres_push_relabel.id;
% toc

display('writing the results into a video file ...')

%%% uncomment this block if you want to re-build the label images. You don't need to do that unless there is more than 1000 tracks.
% close all
% for i = 1:max(dres_dp.track_id)
% % for i = 1:1000
%   bws(i).bw =  text_to_image(num2str(i), 20, 123);
% end
% save([datadir 'label_image_file'], 'bws')

load('tracking-release-v1.0/label_image_file');
m=2;
for i=1:length(bws)                   %% adds some margin to the label images
  [sz1, sz2] = size(bws(i).bw);
  bws(i).bw = [zeros(sz1+2*m,m) [zeros(m,sz2); bws(i).bw; zeros(m,sz2)] zeros(sz1+2*m,m)];
end

input_frames    = [datadir vid_name '/image_%0.8d_0.png'];
output_path     = [cachedir vid_name '_dp_tracked/'];
output_vidname  = [cachedir vid_name '_dp_tracked.avi'];

display(output_vidname)

fnum = max(dres.fr);
bboxes_tracked = dres2bboxes(dres_dp, fnum);  %% we are visualizing the "DP with NMS in the lop" results. Can be changed to show the results of DP or push relabel algorithm.
show_bboxes_on_video(input_frames, bboxes_tracked, output_vidname, bws, 4, -inf, output_path);

