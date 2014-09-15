function save_tracked_boxes_on_image(vid_name, image_name, bboxes_for_frame)
% draws the detected bounding boxes on the image and saves the image to the
% appropriate directory

    env_setup;
    
    im = imread([datadir vid_name '/' image_name]);
    clf; imagesc(im); axis image; axis off; drawnow;
    colorset = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
    
    addpath(genpath('pose-release-ver1.2/'));
    showboxes(im, bboxes_for_frame,colorset);
    rmpath(genpath('pose-release-ver1.2/'));
    
    f = getframe(gca);
    im = frame2im(f);
    imwrite(im,[cachedir vid_name '/body_tracked/' strtok(image_name, '.') '_body_tracked.png']);
%     close;
end