import sys
# add path of the vidutils directory
sys.path.append('../vidutils/python')

import os
import vidutils

vid_dir = '/data/vision/torralba/mooc-video/videos/'

with open('../vids_to_download/to_download_11_10_2014_all.txt', 'r') as url_file:
	for url in url_file:
		vidutils.download_video_url(url, vid_dir)
		# print url
		# print url[-12:]