clear
addpath(genpath('tracking_cvpr11_release_v1.0/'))
addpath(genpath('pose-release-ver1.2/'))
addpath(genpath('edx-vids/'))

%for tracking
addpath('tracking_cvpr11_release_v1.0/3rd_party/voc-release3.1/');           %% this code is downloaded from http://people.cs.uchicago.edu/~pff/latent/
addpath('tracking_cvpr11_release_v1.0/3rd_party/cs2/');                      %% this code is downloaded from http://www.igsystems.com/cs2/index.html and then mex'ed to run faster in matlab.

mex -O tracking_cvpr11_release_v1.0/3rd_party/cs2/cs2mex.c -outdir tracking_cvpr11_release_v1.0/3rd_party/cs2/cs2mex     %% compiling c implementation of push-relabel algorithm. It is downloaded from http://www.igsystems.com/cs2/index.html and then we mex'ed it to run faster in matlab.

%necessary in macosx for ffmpeg
%(http://www.mathworks.com/matlabcentral/answers/32062-error-runing-ffmpeg-in-matlab-function-in-linux)
setenv('PATH', [getenv('PATH') ':/usr/local/bin'])

run('pose-release-ver1.2/code-basic/compile');

addpath(genpath('pose-release-ver1.2/code-basic/fconv'))