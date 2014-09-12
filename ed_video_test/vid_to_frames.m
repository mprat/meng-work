% converts video file into frames
function vid_to_frames(vid_name, vid_dir, frame_rate)
    if ~exist('frame_rate')
      frame_rate = 5;
    end
    
    frames_dir_name = [vid_dir '/' strtok(vid_name, '.')];
    mkdir(frames_dir_name);
    addpath(genpath(frames_dir_name));
    
    % using ffmpeg
    system(['ffmpeg -i ' vid_dir '/' vid_name ' -r ' num2str(frame_rate) ' ' frames_dir_name '/image_%08d_0.png']);
end