clear;
list_of_vids = dir('../../ed-vids/');
[m,n] = size(list_of_vids);
for i=1:m
	disp(list_of_vids(i).name);
end