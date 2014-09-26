function startup(loc)
	if strcmp(loc, 'afsmac')
		path_of_repo = '~/Desktop/mprat_home_afs/meng-work/'
	else
		path_of_repo = '~/Documents/repos/meng-work/'
	end

	addpath([path_of_repo 'MATLAB/']);
	cd(path_of_repo);
end