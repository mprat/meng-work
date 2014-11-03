import requests
import json

url = 'https://www.amara.org/api2/partners/videos/'
headers = {'X-api-username': 'mprat', \
	'X-apikey': 'b42444b1b6dd501ae1b7c3e2976d1deb75013a83'}

def ask_video(youtubeID):
	# this one def exists: BmDricQGK6w
	params = {'video_url': 'http://www.youtube.com/watch?v=' + youtubeID}
	response = requests.get(url, headers=headers, params=params)
	return response.json()

def make_video(youtubeID):
	params = {'video_url': 'http://www.youtube.com/watch?v=' + youtubeID}
	response = requests.post(url, headers=headers, params = params)
	print response.text

def get_subtitle_text(youtubeID):
	response_json = ask_video(youtubeID)
	amara_id = response_json['objects'][0]['id']
	subtitle_url_append = amara_id + '/languages/en/subtitles/'
	params = {'format': 'txt'}
	response = requests.get(url + subtitle_url_append, headers=headers, \
		params = params)
	return response.content

# r = get_subtitle_text('EMaTF9-ArJY')
# r = ask_video('EMaTF9-ArJY')