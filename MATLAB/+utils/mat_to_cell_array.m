function final_image_paths = mat_to_cell_array(filename)
    % frame_num and vid_name come from .mat file
    load(filename);
    % load('../vids_to_download/vid_names_and_frames_9_30_all.mat');
    vid_dir = '~/ed-vids';

    final_image_paths = cell(1, length(final_mat.frame_nums));

    for i=1:length(final_mat.frame_nums)
        vid_name = final_mat.vid_names(i);
        frame_num = final_mat.frame_nums(i);
        frames_dir_name = strcat(vid_dir, '/', strtok(vid_name, '.'));
        out_file_name = sprintf('image_%08d.png', frame_num);
        final_name = strcat(frames_dir_name, '/', out_file_name);
        final_image_paths(i) = cellstr(final_name);
    end
end