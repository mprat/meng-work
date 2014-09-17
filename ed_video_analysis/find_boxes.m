function [bboxes, dres] = find_boxes(vid_name, frame_start_num, frame_stop_num, model, bboxes_fname, bboxes, dres_fname)
    env_setup;
    
    addpath(genpath('pose-release-ver1.2/'));
    
    datadir='~/Dropbox/MEng/edx-vids/';
    
    imlist = dir([datadir vid_name '/*.png']);
    
    parpool;
%     disp('Using BUFFY model');
%     model = load('BUFFY_final');
    
    parfor i=frame_start_num:frame_stop_num
        display(['frame ' num2str(i)])
        tic;
        image_name = [datadir vid_name '/' imlist(i).name];
        im = imread(image_name);
        
        boxes = detect(im, model, min(model.thresh,-1));
        boxes = nms(boxes, .1); % nonmaximal suppression
        bboxes(i).bbox = boxes(1,:);
        fprintf('detection took %.1f seconds\n',toc);
        
       
        % the next line doesn't work in parallel programming
%         save_tracked_boxes_on_image(vid_name, imlist(i).name, boxes(1, :)); % save detected bounding boxes to images
    end
    
    save(bboxes_fname, 'bboxes');
    rmpath(genpath('pose-release-ver1.2/'));
    
    addpath(genpath('tracking_cvpr11_release_v1.0'));
    dres = bboxes2dres(bboxes);
    dres = build_graph(dres);
    save(dres_fname, 'dres');
    rmpath(genpath('tracking_cvpr11_release_v1.0'));
    
    
    delete(gcp);
end