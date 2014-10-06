# somehow the input to this function is a list of predicted labels
# as a temporary, can make that import happen from MATLAB using scipy.io 
# need to figure out where the conversion to labels string-wise happens

import scipy
from scipy import io
import os
import os.path
import re
import argparse
import sys

parser = argparse.ArgumentParser(description='Break the given YouTube video into frames for later processing.')
parser.add_argument('--id', metavar="videoID", type=str)
parser.add_argument('--url', metavar="videoURL", type=str)
# parser.add_argument('--ID', dest="id_given", const=True, default=False, help="Use this flag if you just want to use the youtube video ID.")

args = parser.parse_args()

# can either specify a command-line argument or type the name / ID of a video here
if not args.id and not args.url:
	vid_name = "ID-EMaTF9-ArJY"
	vid_url = "http://www.youtube.com/watch?v=" + vid_name[3:]
elif args.url:
	vid_name = "ID-" + args.url[31:] #if there is a www (if there is NO www, then should be 27)
elif args.id:
	vid_name = args.id
else:
	print "Something horrible happened."
	sys.exit(0)


d = "../../ed-vids/" + vid_name
# get number of files the directory by making sure the filenames match the image_NUMBER.png pattern
num_frames = len([name for name in os.listdir(d) if os.path.isfile(os.path.join(d, name)) and re.match("image_\d+\.png", name)])
label_mat = scipy.io.loadmat('../MATLAB/parser/' + str(num_frames) + '-from-' + vid_name + '-predicted-labels.mat', squeeze_me=True)
labels = label_mat['predicted_label_text']

# labels = ['head', 'head', 'head', 'head', 'head', 'head', 'head', 'head', 'head', 'head', 'slides', 'slides', 'slides', 'slides', 'slides', 'slides', 'slides', 'slides', 'slides', 'slides']

# convert this list into a dictionary

import json


segment_list = []
transition_pos = [0]

prev_label = labels[0]
section_dict = {"start-time": 0, "end-time": 0, "style": prev_label}

# segment_list.append(section_dict)

i = 1
for label in labels[1:]:
	if label == prev_label:
		section_dict["end-time"] += 1000
	else:
		segment_list.append(section_dict)
		transition_pos.append(i*1000)
		prev_label = label
		section_dict = {"start-time": i*1000, "style": label, "end-time": i*1000}
	i += 1

# append the last one
segment_list.append(section_dict)


final_dict = {"segments": segment_list, "slide-transitions": transition_pos}

with open('../../ed-vids/jsons/' + vid_name + '/' + vid_name + '.json', 'w') as outfile:
	json.dump(final_dict, outfile)

# print to the screen for debugging
print json.dumps(final_dict, indent=4)