import vidutils
import numpy as np
import os.path

list_dict = vidutils.csv_ids_frames_labels_to_mat('../vids_to_download/ids_and_frames_training-set-10-2.csv', '../vids_to_download/vid_names_and_frames_and_labels-training-set-10-2.mat')

filenames = list_dict['vid_names']
frames = list_dict['frame_nums']

vid_dir = '../../ed-vids'
filename_index_list = range(len(filenames))
filename_set = set()
filename_dict = {}

for filename in filenames:
	if filename not in filename_set:
		list_of_corresp_indices = np.where(filenames == filename)[0]
		filename_dict[filename] = frames[list_of_corresp_indices]
		filename_set.add(filename)

for filename in filename_dict:
	for frame in filename_dict[filename]:
		vidutils.get_frame(filename, vid_dir, frame)
		
	# remove video
	vidutils.delete_video(filename + '.mp4', vid_dir)