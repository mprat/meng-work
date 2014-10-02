# function get_frame(vid_name, vid_dir, second)
# 	frames_dir_name = [vid_dir '/' strtok(vid_name, '.')]

#     out_file_name = sprintf('image_%08d.png', second)
#     system(['ffmpeg -ss ' num2str(second) ' -i ' vid_dir '/' vid_name ' -frames:v 1 ' frames_dir_name '/' out_file_name]);
# end

import subprocess
import os

def get_frame(vid_name, vid_dir, frame_num):
	os.system('mkdir ' + frames_dir_name)
	out_file_name = 'image_{:08d}.png'.format(i)
	o = 'ffmpeg -ss ' + str(i) + ' -i ' + vid_dir + '/' + vid_name + ' -frames:v 1 ' + frames_dir_name + '/' + out_file_name
	# print o
	os.system(o)

def download_video(youtubeURL):
	o = 'youtube-dl -o "../../ed-vids/ID-%(id)s.%(ext)s" ' + youtubeURL
	# print o
	os.system(o)

# TODO: write get_frames_from_vid_list_and_frame_list

if __name__=="__main__":
	max_frame = 257 # get us 256 frames
	vid_dir = '../../ed-vids'
	youtubeURL = 'https://www.youtube.com/watch?v=8su-otIh2gA'
	vid_id = youtubeURL[-11:]

	download_video(youtubeURL)
	# missing one step here where you get the name of the video

	vid_name = 'ID-' + vid_id + '.mp4'

	frames_dir_name = vid_dir + '/' + vid_name[:-4]

	for i in range(1, max_frame):
		get_frame(vid_name, vid_dir, i)

