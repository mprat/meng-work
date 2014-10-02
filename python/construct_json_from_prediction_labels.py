# somehow the input to this function is a list of predicted labels
# as a temporary, can make that import happen from MATLAB using scipy.io 
# need to figure out where the conversion to labels string-wise happens

import scipy
from scipy import io
vid_name = "ID-aTuYZqhEvuk"
label_mat = scipy.io.loadmat('../MATLAB/parser/256-from-' + vid_name + '-predicted-labels.mat', squeeze_me=True)
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
print json.dumps(final_dict, indent=4)