% saves one frame from video at second specified
function get_frame(vid_name, vid_dir, second)
	frames_dir_name = [vid_dir '/' strtok(vid_name, '.')]
    % mkdir(frames_dir_name);
    % addpath(genpath(frames_dir_name));

    % using ffmpeg
    out_file_name = sprintf('image_%08d.png', second)
    system(['ffmpeg -ss ' num2str(second) ' -i ' vid_dir '/' vid_name ' -frames:v 1 ' frames_dir_name '/' out_file_name]);
end