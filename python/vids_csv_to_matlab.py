import csv
from scipy import io
import numpy

reader = csv.reader(open('ids_and_frames_9_30.csv', 'rb'),delimiter=',')
x = list(reader)

files_list = []
index_list = []
for i in range(1, len(x)):
    files_list.append(x[i][1])
    index_list.append(x[i][7])

files_list = numpy.array(files_list, dtype=numpy.object)
index_list = numpy.array(index_list, dtype=numpy.int16)
scipy.io.savemat('vid_names_and_frames_9_30.mat', mdict={'vid_names': files_list, 'frame_nums': index_list})