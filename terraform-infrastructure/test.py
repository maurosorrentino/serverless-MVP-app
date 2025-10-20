import boto3
import requests
from requests_aws4auth import AWS4Auth

session = boto3.Session()
credentials = session.get_credentials().get_frozen_credentials()
auth = AWS4Auth(
    credentials.access_key,
    credentials.secret_key,
    'eu-west-2',
    'execute-api',
    session_token=credentials.token
)

url = 'https://iyly2v1o2h.execute-api.eu-west-2.amazonaws.com/stage_name/'
r = requests.get(url, auth=auth)
print(r.status_code, r.text)
