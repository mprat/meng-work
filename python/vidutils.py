import subprocess
import os
import os.path
import csv
import scipy
from scipy import io
import numpy
import re

# vid_name DOES NOT HAVE the .mp4 in it
# vid_dir is the directory where the videos / frames are stored
# frame_num is the 1-indexed frame number
def get_frame(vid_name, vid_dir, frame_num):
	frames_dir_name = vid_dir + '/' + vid_name
	if not os.path.isdir(frames_dir_name):
		os.system('mkdir ' + frames_dir_name)
	out_file_name = 'image_{:08d}.png'.format(frame_num)
	# print "desired output file = ", out_file_name 
	if not os.path.isfile(frames_dir_name + '/' + out_file_name):
		# Get the video using the video ID, not the name
		download_video_id(vid_name[3:])
		# print "getting the frame"
		o = 'ffmpeg -loglevel quiet -ss ' + str(frame_num) + ' -i ' + vid_dir + '/' + vid_name + '.mp4 -frames:v 1 ' + frames_dir_name + '/' + out_file_name
		# print o
		os.system(o)

# give the full youtube URL to download the video from
def download_video_url(youtubeURL):
	if not os.path.isfile('../../ed-vids/ID-' + youtubeURL[32:] + '.mp4'):
		o = 'youtube-dl -q -o "../../ed-vids/ID-%(id)s.%(ext)s" ' + youtubeURL
		# print o
		os.system(o)
	# else:
		# print "File already exists"

# youtubeID is the 11-character string that is the youtube ID
def download_video_id(youtubeID):
	download_video_url('https://www.youtube.com/watch?v=' + youtubeID)

# vid_name here includes .mp4 / extension
# TODO: check whether it includes .mp4 or not
def delete_video(vid_name, vid_dir):
	os.system('rm ' + vid_dir + '/' + vid_name)

def get_video_length_secs(vid_name):
	probe = subprocess.check_output(["ffprobe", "-v", "quiet",  "-show_format",  "../../ed-vids/" + vid_name + ".mp4"])
	return int(float(re.search("duration=\d+.?\d+", probe).group(0)[9:]))

def csv_ids_frames_labels_to_mat(csv_name, matlab_name):
	# reader = csv.reader(open('../vids_to_download/ids_and_frames_training-10-2.csv', 'rb'),delimiter=',')
	reader = csv.reader(open(csv_name, 'rb'),delimiter=',')
	x = list(reader)

	files_list = []
	index_list = []
	label_list = []
	for i in range(5, 28):
	    files_list.append('ID-' + x[i][0])
	    index_list.append(x[i][2])
	    label_list.append(x[i][4])
	    files_list.append('ID-' + x[i][0])
	    index_list.append(x[i][5])
	    label_list.append(x[i][7])
	    files_list.append('ID-' + x[i][0])
	    index_list.append(x[i][8])
	    label_list.append(x[i][10])
	    files_list.append('ID-' + x[i][0])
	    index_list.append(x[i][11])
	    label_list.append(x[i][13])
	    files_list.append('ID-' + x[i][0])
	    index_list.append(x[i][14])
	    label_list.append(x[i][16])

	files_list = numpy.array(files_list, dtype=numpy.object)
	index_list = numpy.array(index_list, dtype=numpy.int16)
	label_list = numpy.array(label_list, dtype=numpy.object)

	list_dict = {'vid_names': files_list, 'frame_nums': index_list, 'labels': label_list}
	scipy.io.savemat(matlab_name, mdict=list_dict)
	# scipy.io.savemat('../vids_to_download/vid_names_and_frames_and_labels-training-set-10-2.mat', mdict={'vid_names': files_list, 'frame_nums': index_list, 'labels': label_list})
	return list_dict

# TODO: write get_frames_from_vid_list_and_frame_list

if __name__=="__main__":
	# max_frame = 257 # get us 256 frames
	# vid_dir = '../../ed-vids'
	# youtubeURL = 'https://www.youtube.com/watch?v=8su-otIh2gA'
	# vid_id = youtubeURL[-11:]

	# download_video_url(youtubeURL)
	# # missing one step here where you get the name of the video

	# vid_name = 'ID-' + vid_id + '.mp4'

	# frames_dir_name = vid_dir + '/' + vid_name[:-4]

	# for i in range(1, max_frame):
	# 	get_frame(vid_name, vid_dir, i)

	csv_ids_frames_labels_to_mat('../vids_to_download/ids_and_frames_training-set-10-2.csv', '../vids_to_download/vid_names_and_frames_and_labels-training-set-10-2.mat')

