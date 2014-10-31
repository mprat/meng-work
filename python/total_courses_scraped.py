import json

date_to_use = '10-30-2014'
with open('all-courses-enhanced-' + date_to_use + '.json', 'r') as jsonfileprev
	courses_prev = json.load(jsonfileprev)
# jsonfileprev.close()

print len(courses_prev)