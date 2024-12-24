import os
from mailjet_rest import Client


def get_mailjet_client():
    api_key = os.environ["MAILJET_APIKEY"]
    api_secret = os.environ["MAILJET_SECRET"]
    return Client(auth=(api_key, api_secret), version='v3.1')
