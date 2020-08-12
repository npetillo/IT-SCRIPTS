from __future__ import print_function
import json
import os
import httplib2
import urllib
import sys
import requests
import jwt

from httplib2 import Http
from json import dumps

from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

from httplib2 import Http

from oauth2client.service_account import ServiceAccountCredentials

headers = {}

scopes = ['https://www.googleapis.com/auth/admin.directory.user',
          'https://www.googleapis.com/auth/admin.directory.group']

credentials = ServiceAccountCredentials.from_json_keyfile_name('python-2-email-3e7929af352e.json', scopes=scopes)

account_sub = 'nicholas.petillo@translationllc.com'

delegated_credentials=credentials.create_delegated(account_sub)

httplib2.debuglevel=5

http = delegated_credentials.authorize(Http())

service = discovery.build('admin', 'directory_v1', http=http)


r = requests.get('https://api.sheety.co/b23792e6-0c40-45d7-b35e-3f2b106a81ed')

packages_json = r.json()

emails = []
firstnames = []
lastnames = []
user = []
group_add_email = []
slack_add_email = []
company = []
location =[]
payload_zoom = []

for x in packages_json:
    emails.append(x["newHireEmailAddress(First.Last@Translationllc.Com)"])

for x in packages_json:
    firstnames.append(x["firstname"])

for x in packages_json:
    lastnames.append(x["lastname"])

for x in packages_json:
    location.append(x["officeLocation"])

for x in packages_json:
    company.append(x["whatCompanyWillThisPersonWorkFor"])

for x,y,z in zip(emails,firstnames,lastnames):
    user.append({"name": {"familyName": z, "givenName": x,}, "password": "Translation10jay", "primaryEmail": x, "changePasswordAtNextLogin": True})

for x in emails:
    group_add_email.append({'email': x,})




for x in user:
    try:
        service.users().insert(body=x).execute()
    except:
        pass


for x in group_add_email:
    try:
        service.members().insert(groupKey='allagency@translationllc.com',body=x).execute()
        service.members().insert(groupKey='alltranslationteam@translationllc.com', body=x).execute()
        service.members().insert(groupKey='all@translationllc.com', body=x).execute()
    except:
        pass




for x,y in zip(company,group_add_email):
    try:
        if x == "United Masters":
            service.members().insert(groupKey='all.um.team@unitedmasters.com', body=y).execute()
    except:
        pass


for x,y,z in zip(company,location,group_add_email):
    try:
        if x == "United Masters" and y == "Times Sq":
            service.members().insert(groupKey='um.nyc@translationllc.com', body=y).execute()
    except:
        pass

for x,y,z in zip(company,location,group_add_email):
    try:
        if x == "United Masters" and y == "Dumbo - 10 Jay Street":
             service.members().insert(groupKey='um.nyc@translationllc.com', body=y).execute()
    except:
        pass

for x, y, z in zip(company, location, group_add_email):
    try:
        if x == "United Masters" and y == "San Fransisco":
            service.members().insert(groupKey='sf@unitedmasters.com', body=y).execute()
    except:
        pass

#slack_invite##########


headers = {
    'Authorization': 'Bearer <token>',
    'Cache-Control': 'no-cache',
}

for x in emails:
    slack_add_email.append({'email': (None, x)},)

for x in slack_add_email:
    slack_invite = requests.post('https://slack.com/api/users.admin.invite', headers=headers, files=x)
###################################

#Zoom Invite###

encoded = jwt.encode({"iss": "l-pJkjklfajsdklfOPFTnSIGzyr3gI0aA","exp": "1496091964000"}, 'Kjklasjdkfjasdl4k0qiEoyq0xYjfoVy6i74xijvsX10R9Qr1f', algorithm='HS256').decode('utf-8')


zoom_url = "https://api.zoom.us/v2/users"

zoom_headers = {
    'Authorization': "Bearer {0}" .format(encoded),
    'Content-Type': "application/json"
    }

for x,y,z in zip(emails,firstnames,lastnames):
    payload_zoom.append({"action": "create","user_info": {"email": x,"type": "2", "first_name": y, "last_name": z}})

for x in payload_zoom:
    try:
        zoom_invite = requests.request("POST", zoom_url, json=x, headers=zoom_headers)
    except:
        pass






