def txt_to_list(filename):
	f = open(filename)
	list_in_file = f.read().split('\n')
	f.close()
	return list_in_file


ids1 = txt_to_list('/Users/mprat/Documents/repos/meng-work/vids_to_download/ids_26-09-2014.txt')
# ids1 = f1.read().split('\n')
# f1.close()
ids2 = txt_to_list('/Users/mprat/Desktop/ed-vids/names.txt')
# ids2 = f.read().split('\n')
# f.close()
overlap = list(set(ids1) & set(ids2))
overlap = [x for x in overlap if x != '']
# print "\nhttp://youtube.com/watch?v=".join(overlap)
# overlap = txt_to_list()

longnames = txt_to_list("/Users/mprat/Desktop/ed-vids/names_long.txt")
long_to_short = [x[-15:-4] for x in longnames]
index_list = []
for i in overlap:
	if long_to_short.index(i) > 0:
		index_list.append(long_to_short.index(i))
for i in index_list:
	print longnames[i]