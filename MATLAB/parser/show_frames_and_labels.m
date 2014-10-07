function show_frames_and_labels(vid_name)
% vid_name is the name of the video, of the form 'ID-EMaTF9-ArJY'
	
	max_framenum = length(dir(['~/ed-vids/' vid_name '/image*.png'])); % only count the .png files
	load(sprintf('%d-from-%s-predicted-labels.mat', max_framenum, vid_name));

	for index=1:max_framenum
		im = imread(list_of_filenames{index});
		imshow(im);
		disp(predicted_label_text(index));
		pause;
	end

end