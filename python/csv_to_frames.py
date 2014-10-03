import csv
import scipy
from scipy import io
import numpy
import vidutils

reader = csv.reader(open('../vids_to_download/ids_and_frames_training-10-2.csv', 'rb'),delimiter=',')
x = list(reader)

files_list = []
index_list = []
label_list = []
for i in range(5, 28):
    files_list.append(x[i][0])
    index_list.append(x[i][2])
    label_list.append(x[i][4])
    files_list.append(x[i][0])
    index_list.append(x[i][5])
    label_list.append(x[i][7])
    files_list.append(x[i][0])
    index_list.append(x[i][8])
    label_list.append(x[i][10])
    files_list.append(x[i][0])
    index_list.append(x[i][11])
    label_list.append(x[i][13])
    files_list.append(x[i][0])
    index_list.append(x[i][14])
    label_list.append(x[i][16])

files_list = numpy.array(files_list, dtype=numpy.object)
index_list = numpy.array(index_list, dtype=numpy.int16)
label_list = numpy.array(label_list, dtype=numpy.object)

scipy.io.savemat('../vids_to_download/vid_names_and_frames_and_labels-training-set-10-2.mat', mdict={'vid_names': files_list, 'frame_nums': index_list, 'labels': label_list})