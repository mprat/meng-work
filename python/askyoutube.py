import requests

url = 'https://www.googleapis.com/youtube/v3/videos'
params = {'id': 'EMaTF9-ArJY', \
	'key': 'AIzaSyDCcT-tfWquyAXbjoxlD8rg01p73pFnpqY', \
	'part': 'contentDetails', \
	'fields': 'items(id,contentDetails(duration,caption))'}
response = requests.get(url, params=params)
print response.text