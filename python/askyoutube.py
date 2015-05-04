import requests
import matplotlib.pyplot as plt
import re

def ask_youtube(ID):
	url = 'https://www.googleapis.com/youtube/v3/videos'
	params = {'id': ID, \
		'key': 'AIzaSyDCcT-tfWquyAXbjoxlD8rg01p73pFnpqY', \
		'part': 'contentDetails', \
		'fields': 'items(id,contentDetails(duration,caption))'}
	response = requests.get(url, params=params)
	if ((response.status_code == 200) and (len(response.json()["items"]) > 0)):
		return response.json()["items"][0]["contentDetails"]["duration"]
	else:
		print "ID ", ID, " doesn't exist on youtube anymore"
		return "DNE"

def duration_to_seconds(duration):
	minsecdict = re.match("PT(?P<mins>[0-9]+)?M?(?P<secs>[0-9]+)?S?", duration).groupdict()
	if minsecdict["mins"] is None:
		minsecdict["mins"] = 0
	if minsecdict["secs"] is None:
		minsecdict["secs"] = 0
	return int(minsecdict["mins"])*60 + int(minsecdict["secs"])

def duration_to_mins(duration):
	minsecdict = re.match("PT(?P<mins>[0-9]+)?M?(?P<secs>[0-9]+)?S?", duration).groupdict()
	if minsecdict["mins"] is None:
		minsecdict["mins"] = 0
	if minsecdict["secs"] is None:
		minsecdict["secs"] = 0
	return float(minsecdict["mins"]) + float(minsecdict["secs"]) / 60.0


durations_strings = []
durations = []
durations_mins = []

with open('../vids_to_download/to_download_11_10_2014_all_IDS.txt') as f:
	ID = f.readline()
	while ID:
		duration = ask_youtube(ID)
		durations_strings.append(duration)
		if duration != "DNE":
			durations.append(duration_to_seconds(duration))
			durations_mins.append(duration_to_mins(duration))
		ID = f.readline()


plt.hist(durations, bins=10)
plt.title("Histogram of video lengths")
plt.xlabel("Length (seconds)")
plt.ylabel("Frequency")
plt.show()

plt.hist(durations_mins, bins=30)
plt.title("Histogram of video lengths")
plt.xlabel("Length (mins)")
plt.ylabel("Frequency")
plt.show()