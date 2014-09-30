clear;
list_of_vids = dir('~/ed-vids/');
[m,n] = size(list_of_vids);

for i=1:m
	n = list_of_vids(i).name;
	if size(strfind(n, '.mp4'), 2) > 0
		utils.vid_to_frames(n, '~/ed-vids')
	end
end
