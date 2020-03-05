#!/usr/bin/python3

import os
import sys
import json
import logging
import requests as req

corpid = "wwf05d6d6460f360c6"
corpsecret = "9YX0uoLFqbtYJhFmZGBAzT9jMtKxVgHAuIz3jkrR2h0"
agentid = "1000002"
token_url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=" + corpid + \
            "&corpsecret=" + corpsecret


logging.basicConfig(level=logging.DEBUG,
		    format='%(asctime)s:%(levelname)s:%(name)s:%(message)s',
                    datefmt="%a, %d %b %Y %H:%M:%S",
                    filename=os.path.join("/tmp", "wx_message.log"),
                    filemode='a')


def get_token(url):
    r = req.get(url)
    token_value = list(r.json().values())[2]
    return token_value


token = get_token(token_url)
msg_url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=" + token
msg_to = sys.argv[1]
subject = sys.argv[2]
msg_body = sys.argv[2] + "\n\n" +sys.argv[3]

post_body = {
    "touser": msg_to,
    "msgtype": "text",
    "agentid": agentid,
    "text": {
        "content": msg_body
    },
    "safe": 0
}


def send_msg(url, p_body):
    post = req.post(msg_url, data=json.dumps(p_body))


send_msg(msg_url, post_body)
logging.info('msg_to:' + msg_to + '||suject:' + subject + '||msg:' + msg_body)

