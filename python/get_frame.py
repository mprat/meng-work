# function get_frame(vid_name, vid_dir, second)
# 	frames_dir_name = [vid_dir '/' strtok(vid_name, '.')]

#     out_file_name = sprintf('image_%08d.png', second)
#     system(['ffmpeg -ss ' num2str(second) ' -i ' vid_dir '/' vid_name ' -frames:v 1 ' frames_dir_name '/' out_file_name]);
# end

import subprocess
import os

max_frame = 257 # get us 256 frames
vid_dir = '../../ed-vids'
vid_name = 'ID-EMaTF9-ArJY.mp4'
frames_dir_name = vid_dir + '/' + vid_name[:-4]

for i in range(1, max_frame):
	out_file_name = 'image_{:08d}.png'.format(i)
	o = 'ffmpeg -ss ' + str(i) + ' -i ' + vid_dir + '/' + vid_name + ' -frames:v 1 ' + frames_dir_name + '/' + out_file_name
	print o
	os.system(o)

