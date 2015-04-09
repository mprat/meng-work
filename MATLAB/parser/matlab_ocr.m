I = imread('~/Documents/repos/vid-to-json/example/ID-CzyXIRx67qU_144-slide.png');
txt = ocr(I);
Iocr = insertObjectAnnotation(I, 'rectangle', ...
                           txt.WordBoundingBoxes, ...
                           txt.WordConfidences);
                       
disp(txt.Text)
imshow(Iocr);