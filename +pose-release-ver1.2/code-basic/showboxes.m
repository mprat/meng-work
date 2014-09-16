function im = showboxes(im, boxes, partcolor)

if nargin < 3,
  partcolor = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
end

[sz1, sz2, sz3] = size(im);
boxes = round(boxes);

imagesc(im); axis image; axis off;
if ~isempty(boxes)
  numparts = floor(size(boxes, 2)/4);
  for i = 1:numparts
    x1 = boxes(:,1+(i-1)*4);
    y1 = boxes(:,2+(i-1)*4);
    x2 = boxes(:,3+(i-1)*4);
    y2 = boxes(:,4+(i-1)*4);
    
    % draw thicker lines on the image
    line([x1 x1 x2 x2 x1]',[y1 y2 y2 y1 y1]','color',partcolor{i},'linewidth',2);

    % save on image the lines
%     color_to_draw = [0, 0, 0];
%     switch partcolor{i}
%         case 'r'
%             color_to_draw = [255, 0, 0];
%         case 'g'
%             color_to_draw = [0, 255, 0];
%         case 'b'
%             color_to_draw = [0, 0, 255];
%     end
%     
%     for k=1:sz3
%         im(max(1,y1):min(sz1,y1),  max(1,x1):min(sz2,x2),  k) = color_to_draw(k);
%         im(max(1,y2):min(sz1,y2),  max(1,x1):min(sz2,x2),  k) = color_to_draw(k);
%         im(max(1,y1):min(sz1,y2),  max(1,x1):min(sz2,x1),  k) = color_to_draw(k);
%         im(max(1,y1):min(sz1,y2),  max(1,x2):min(sz2,x2),  k) = color_to_draw(k);
%     end
  end
end
% drawnow;
  