import json
from collections import Counter
import requests
import isodate

with open('all-courses-enhanced-11-03-2014.json', 'r') as jsonfile:
	course_info = json.load(jsonfile)

all_vids = []

for course in course_info:
	all_vids.extend(course['vid_ids'])

c = Counter(all_vids)
overlaps = ["http://youtube.com/watch?v=" + vid_id for vid_id in c.keys() if c[vid_id] > 1]
nonoverlaps = list(set(all_vids))

vids_to_download = open('to_download_11_10_2014-less-30-mins.txt', 'w')
for vid_id in nonoverlaps:
	url = 'https://www.googleapis.com/youtube/v3/videos'
	params = {'id': vid_id, \
		'key': 'AIzaSyDCcT-tfWquyAXbjoxlD8rg01p73pFnpqY', \
		'part': 'contentDetails', \
		'fields': 'items(id,contentDetails(duration,caption))'}
	response = requests.get(url, params=params)
	if response:
	# print response.text
		duration = isodate.parse_duration(response.json()['items'][0]['contentDetails']['duration'])
		if duration.total_seconds() < 60 * 30:
			vids_to_download.write("http://www.youtube.com/watch?v=" + vid_id + "\n")
	else:
		print response.text

# vids_to_download = open('to_download_11_10_2014.txt', 'w')
# for vid_id in nonoverlaps:
# 	vids_to_download.write("http://www.youtube.com/watch?v=" + vid_id + "\n")
vids_to_download.close()