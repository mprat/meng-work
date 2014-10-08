function text = get_text(vid_name, frame_num)
	% vid_name is the name of the video, of the form 'ID-EMaTF9-ArJY'
	% text right now is the MATLAB returning of the 

	max_framenum = length(dir(['~/ed-vids/' vid_name '/image*.png'])); % only count the .png files

	load(sprintf('%d-from-%s-predicted-labels.mat', max_framenum, vid_name));
	load(sprintf('%d-from-%s.mat', max_framenum, vid_name));

	% get features of all the slides things.
	% features_slides = featureSet(predicted_label_num==2, :);
	% filenames_slide = list_of_filenames(predicted_label_num==2);
	im = imread(list_of_filenames{frame_num});

	text = ocr(im);
end