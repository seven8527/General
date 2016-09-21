# -*- coding:utf-8 -*-
import urllib, urllib2

url = 'http://ijoke.site88.net/login.php'
post_data={
    'username':'小强',
    'password':'4556'
}

web_data = urllib2.urlopen(url, data=urllib.urlencode(post_data))
print(web_data.read().decode('gbk'))