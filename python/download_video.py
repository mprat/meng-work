import os
youtubeURL = 'https://www.youtube.com/watch?v=aTuYZqhEvuk'

o = 'youtube-dl -o "../../ed-vids/ID-%(id)s.%(ext)s" ' + youtubeURL
print o
os.system(o)