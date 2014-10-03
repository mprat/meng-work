function [final_image_paths, labels] = mat_to_cell_array(filename)
    % frame_num and vid_name come from .mat file
    load(filename);
    vid_dir = '~/ed-vids';

    final_image_paths = cell(1, length(frame_nums));

    % labels = 

    for i=1:length(frame_nums)
        vid_name_f = vid_names(i);
        frame_num_f = frame_nums(i);
        frames_dir_name = strcat(vid_dir, '/', strtok(vid_name_f, '.'));
        out_file_name = sprintf('image_%08d.png', frame_num_f);
        final_name = strcat(frames_dir_name, '/', out_file_name);
        final_image_paths(i) = cellstr(final_name);
    end
end