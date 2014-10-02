import csv
import scipy
from scipy import io
import numpy

reader = csv.reader(open('../vids_to_download/ids_and_frames_10_2.csv', 'rb'),delimiter=',')
x = list(reader)

files_list = []
index_list = []
label_list = []
for i in range(4, len(x)):
    files_list.append(x[i][1])
    index_list.append(x[i][7])
    label_list.append(x[i][9])
    files_list.append(x[i][1])
    index_list.append(x[i][10])
    label_list.append(x[i][12])
    files_list.append(x[i][1])
    index_list.append(x[i][13])
    label_list.append(x[i][15])
    files_list.append(x[i][1])
    index_list.append(x[i][16])
    label_list.append(x[i][18])

files_list = numpy.array(files_list, dtype=numpy.object)
index_list = numpy.array(index_list, dtype=numpy.int16)
scipy.io.savemat('../vids_to_download/vid_names_and_frames_and_labels_10_2.mat', mdict={'vid_names': files_list, 'frame_nums': index_list, 'labels': label_list})