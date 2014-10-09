function bbs = edge_boxes_from_vid_name_frame(vid_name, frame_num)
	% vid_name is the name of the video, of the form 'ID-EMaTF9-ArJY'
	% frame is the frame number

	filename = sprintf('~/ed-vids/%s/image_%08d.png', vid_name, frame_num);

	model=load('~/meng-work/MATLAB/+edge_tools/models/forest/modelBsds'); model=model.model;
	model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

	%% set up opts for edgeBoxes (see edgeBoxes.m) - taken directly from example
	opts = edge_tools.edgeBoxes;
	opts.alpha = .65;     % step size of sliding window search
	opts.beta  = .75;     % nms threshold for object proposals
	opts.minScore = .05;  % min score of boxes to detect
	opts.maxBoxes = 1e4;  % max number of boxes to detect

	%% detect Edge Box bounding box proposals (see edgeBoxes.m)
	I = imread(filename);
	tic, bbs=edge_tools.edgeBoxes(I,model,opts); toc

	%% show the bounding boxes on the image
	if (1)
		figure(1); imshow(I);
		% the 5th element of bbs is the score, but it seems to be breaking the 'draw' function?
		dollar_toolbox.detector.bbApply('draw', bbs(:, 1:4));
	end
end