function startup(loc)
	if strcmp(loc, 'afsmac')
		path_of_repo = '~/Desktop/mprat_home_afs/meng-work/'
    else if strcmp(loc, 'mac')
		path_of_repo = '~/Documents/repos/meng-work/'
	% else if strcmp(loc, 'afs')
	% 	path_of_repo = '/afs/csail.mit.edu/u/m/mprat/meng-work/'
	else
		path_of_repo = '~/meng-work/'
	end

	addpath([path_of_repo 'MATLAB/']);
	cd(path_of_repo);
end