from __future__ import print_function
import json
import requests
import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/admin.directory.user', 'https://www.googleapis.com/auth/admin.directory.group']
creds = None

if os.path.exists('token.pickle'):
    with open('token.pickle', 'rb') as token:
        creds = pickle.load(token)
# If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

service = build('admin', 'directory_v1', credentials=creds)


r = requests.get('https://sheetdb.io/api/v1/xjzx9xzer55t4')

packages_json = r.json()

emails = []
firstnames = []
lastnames = []
user = []
group_add_email = []
company = []



for x in packages_json:
    emails.append(x["New Hire Email Address (first.last@translationllc.com)"])

for x in packages_json:
    firstnames.append(x["Firstname"])

for x in packages_json:
    lastnames.append(x["Lastname"])

for x in packages_json:
    company.append(x["What Company Will This Person Work For"])

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
    except:
        pass



for x,y in zip(company,group_add_email):
    if x == "United Masters":
        service.members().insert(groupKey='all.um.team@unitedmasters.com', body=y).execute()