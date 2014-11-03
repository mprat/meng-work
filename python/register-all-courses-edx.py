from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC

import json
import pprint
pp = pprint.PrettyPrinter(indent=4)

date_to_use = '11-03-2014'
jsonfile = open('all-courses-' + date_to_use + '.json', 'r')
course_info = json.load(jsonfile)
jsonfile.close()

driver = webdriver.Firefox()
driver.get('https://courses.edx.org/login')

raw_input('log in yourself')

# input('Click "Archived" on the side tab')

# list_of_course_links = driver.find_elements_by_class_name("course-link")

# todo: compress this?
for course in course_info:
	pp.pprint(course)
	driver.get(course['url'])
	driver.switch_to_frame(driver.find_element_by_class_name('iframe-register'))

avail = ""
if 'Availability' in course:
	avail = course['Availability']
elif 'availability' in course:
	avail = course['availability']


if avail != 'Starting Soon':
	# if we are already registered, just access the courseware
	try:
		# driver.find_element_by_class_name("access-courseware")
		driver.find_element_by_class_name("access-courseware").click()
	except:
		if 'has-option-verified' in driver.find_element_by_class_name("action-register").get_attribute('class'):
			# enroll in a verified course under honor system
			driver.find_element_by_class_name("action-register").click()
			element = WebDriverWait(driver, 10).until(
		        EC.presence_of_element_located((By.NAME, "honor_mode"))
		    )
			driver.find_element_by_name("honor_mode").click()
		else:
			# enroll in a regular course
			driver.find_element_by_class_name("action-register").click()

	# raw_input('press enter to continue')