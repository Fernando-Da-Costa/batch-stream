import requests

url = "http://169.254.169.254/metadata/identity/oauth2/token"
headers = {"Metadata": "true"}
params = {
    "api-version": "2018-02-01",
    "resource": "https://storage.azure.com/"
}

response = requests.get(url, headers=headers, params=params)
print(response.text)
