import requests

url = "https://www.virustotal.com/api/v3/analyses/u-9d116b1b0c1200ca75016e4c010bc94836366881b021a658ea7f8548b6543c1e-1707146294"

headers = {
    "accept": "application/json",
    "x-apikey": "2fe0b6865ed86a9de77b1037c4b91637390d709a384ff940ed784bb68c22ad38"
}

response = requests.get(url, headers=headers)

print(response.text)