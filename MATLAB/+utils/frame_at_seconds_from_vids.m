function frame_at_seconds_from_vids(vid_list, second_list, vid_dir)
	for i=1:length(vid_list)
		utils.get_frame(char(vid_list(i)), vid_dir, second_list(i));
	end
end