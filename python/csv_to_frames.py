import vidutils
import numpy as np
import os.path

list_dict = vidutils.csv_ids_frames_labels_to_mat('../vids_to_download/ids_and_frames_training-set-10-2.csv', '../vids_to_download/vid_names_and_frames_and_labels-training-set-10-2.mat')

filenames = list_dict['vid_names']
frames = list_dict['frame_nums']

vid_dir = '../../ed-vids'
filename_index_list = range(len(filenames))

for i in filename_index_list:
	# download video if it does not exist already
	if not os.path.isfile(vid_dir + '/' + filenames[i] + '.mp4'):
		vidutils.download_video_id(filenames[i][3:]) # get rid of the "ID-" from the name. In the future, do this step in parallel to the matrix saving so that nothing gets messed up
	# get indices where that same video appears for a frame
	list_of_corresp_indices = np.where(filenames == filenames[i])[0]
	# get the list of frames corresponding to the video in question
	frames_sublist = frames[list_of_corresp_indices]
	# get those frames that don't exist already
	for frame in frames_sublist:
		vidutils.get_frame(filenames[i], vid_dir, frame)
	# delete video
	vidutils.delete_video(filenames[i] + '.mp4', vid_dir)
	# remove list_of_corresp_indices from filename_index_list
	for index in list_of_corresp_indices:
		filename_index_list.remove(index)