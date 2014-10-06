import os
import vidutils
import argparse

parser = argparse.ArgumentParser(description='Break the given YouTube video into frames for later processing.')
parser.add_argument('vid_URL', metavar="youtube_URL", type=str, help="The Youtube video link for the desired video. Should be of the form 'https://www.youtube.com/watch?v=aTuYZqhEvuk'.")
# parser.add_argument('--ID', dest="id_given", const=True, default=False, help="Use this flag if you just want to use the youtube video ID.")

args = parser.parse_args()
vid_dir = '../../ed-vids'
vid_name = 'ID-' + args.vid_URL[32:]

# download video
vidutils.download_video_url(args.vid_URL)
# get length of video
vid_duration = vidutils.get_video_length_secs(vid_name)
# for loop to get all frames
for frame_num in range(1, vid_duration + 1):
	vidutils.get_frame(vid_name, vid_dir, frame_num)
# delete video
vidutils.delete_video(vid_name + '.mp4', vid_dir)
# print video name to later use in MATLAB
print vid_name