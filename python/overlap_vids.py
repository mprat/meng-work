f1 = open('/Users/mprat/Documents/repos/meng-work/vids_to_download/ids_26-09-2014.txt')
ids1 = f1.read().split('\n')
f1.close()
f = open('/Users/mprat/Desktop/ed-vids/names.txt')
ids2 = f.read().split('\n')
f.close()
overlap = list(set(ids1) & set(ids2))
overlap = [x for x in overlap if x != '']
print "\nhttp://youtube.com/watch?v=".join(overlap)