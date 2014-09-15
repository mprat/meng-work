% set up necessary global variables first
if ~exist('datadir', 'var')
    datadir = '~/Dropbox/MEng/edx-vids/';
end

if ~exist('cachedir', 'var')
    cachedir = '~/Dropbox/MEng/cache/';
end

addpath(genpath(datadir));
addpath(genpath(cachedir));

%necessary in macosx for ffmpeg
%(http://www.mathworks.com/matlabcentral/answers/32062-error-runing-ffmpeg-in-matlab-function-in-linux)
setenv('PATH', [getenv('PATH') ':/usr/local/bin'])