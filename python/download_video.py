import os
import vidutils
import argparse
import sys

parser = argparse.ArgumentParser(description='Break the given YouTube video into frames for later processing.')
parser.add_argument('--url', metavar="youtubeURL", type=str)
# parser.add_argument('--ID', dest="id_given", const=True, default=False, help="Use this flag if you just want to use the youtube video ID.")

args = parser.parse_args()
vid_dir = '../../ed-vids'

# can either specify a command-line argument or type the name / ID of a video here
if not args.url:
	vid_name = 'ID-EMaTF9-ArJY'
	vid_url = "http://youtube.com/watch?v=" + vid_name[3:]
else:
	vid_name = 'ID-' + args.url[32:]
	vid_url = args.url

# download video
vidutils.download_video_url(vid_url)
# get length of video
vid_duration = vidutils.get_video_length_secs(vid_name)
# for loop to get all frames
for frame_num in range(1, vid_duration + 1):
	vidutils.get_frame(vid_name, vid_dir, frame_num)
# delete video
vidutils.delete_video(vid_name + '.mp4', vid_dir)
# print video name to later use in MATLAB
print vid_name