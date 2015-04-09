function slide_diffs(vid_name)
	% vid_name is the name of the video, of the form 'ID-EMaTF9-ArJY'
	max_framenum = length(dir(['~/ed-vids/' vid_name '/image*.png'])); % only count the .png files

% 	load(sprintf('%d-from-%s-predicted-labels.mat', 256, vid_name));
    d2 = load(sprintf('%d-from-%s.mat', 256, vid_name));
	d3 = load('256-from-ID-EMaTF9-ArJY-predicted-labels-model-3-class-all-training-10-2-samples');

	% get features of all the slides things.
	features_slides = d2.test_features(d3.predicted_label_num==2, :);
	filenames_slide = d2.list_of_test_filenames(d3.predicted_label_num==2);
	num_vecs = size(features_slides, 1);

	% figure('Name', 'Current', 'NumberTitle', 'off');
	% figure('Name', 'Previous', 'NumberTitle', 'off');
	% figure('Name', 'Next', 'NumberTitle', 'off');
	figure;

	for index=1:max_framenum
		imcur = imread(filenames_slide{index});
		subplot(2,2,1), imshow(imcur, 'InitialMagnification', 50), title('Current')
		if index + 1 <= num_vecs
			disp('one after')
			norm(features_slides(index, :) - features_slides(index + 1, :))
			imnext = imread(filenames_slide{index + 1});
			subplot(2,2,2), imshow(imnext, 'InitialMagnification', 50), title('Next')
		end
		if index - 1 >= 1
			disp('one before')
			norm(features_slides(index - 1, :) - features_slides(index, :))
			imprev = imread(filenames_slide{index - 1});
			subplot(2,2,3), imshow(imprev, 'InitialMagnification', 50), title('Previous')
		end
		pause;
	end
end