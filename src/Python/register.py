#!user/bin/python
# -*- coding:utf-8 -*-
import  urllib, urllib2

url = 'http://ijoke.site88.net/register.php?format=json'

username = raw_input("请输入用户名 :")
password = raw_input('\n请输入密码 :')

if username =='' :
    print '用户名不能为空'
if password == '':
    print '密码不能为空'

send_data = {
    'username':username,
    'password':password
}
resp_data = urllib2.urlopen(url, data=urllib.urlencode(send_data))

print(resp_data.read().decode('gbk'))