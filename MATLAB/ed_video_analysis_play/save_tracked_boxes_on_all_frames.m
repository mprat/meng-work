function save_tracked_boxes_on_all_frames(vid_name)
    env_setup;

    imlist=dir([datadir vid_name '/*.png']);
    bboxes_fname = [cachedir '/' vid_name '/' vid_name '_bboxes.mat'];
    
    try
        load(bboxes_fname)
    catch
        disp('File not found. Are your directories right?')
        error('Quitting program');
    end
  
    % only do as many images as you have bounding boxes for
    for i=1:length(bboxes)
        image_name = imlist(i).name;
        disp(image_name)
        save_tracked_boxes_on_image(vid_name, image_name, bboxes(i).bbox);
    end
   
    disp('Finished');
end