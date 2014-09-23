% take in a video, output a JSON parsing

vid_name = 'test';
output = {};
output(1).num = 1;
output(1).head = 1;
output(2).num = 2;
output(2).head = 1;

json = jsonlab.savejson('', output, 'FileName', [vid_name '.json']);