#!/usr/bin/python3

import requests

corpid = "wwf05d6d6460f360c6"

corpsecret = "9YX0uoLFqbtYJhFmZGBAzT9jMtKxVgHAuIz3jkrR2h0"

url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=" + corpid + \
      "&corpsecret=" + corpsecret

token = requests.get(url)

values = list(token.json().values())

print(values[2])
