# -*- coding: utf-8 -*-
import sys
import sys
import os
import re
import urllib2

url0="http://mp3.baidu.com/m?f=ms&tn=baidump3&ct=134217728&lm=0&rn=&word="
webcoding='gbk'
localcoding=sys.getfilesystemencoding()
downdir='~/'
def listInfo(url):
    """
    获取搜索到的mp3列表
    """
    html = urllib2.urlopen(url)
    a = html.readline()
    aaa=[]
    url=[]
    while a:
        if a.find('<td class=d><a href=')!=-1:
            aa=[]
            for i in range(8):
                a=a.decode(webcoding,'ignore')
                if i==0:
                    tmp=re.findall('<td class=d><a href="(.*)" title.*target="_blank">(.*)</a>.*',a)
                    url=url+[tmp[0][0]]
                    a=tmp[0][1]
                    a=re.sub(r'<[^<>]*>','',a)
                    a=re.sub(r' ','',a)
                else:
                    a=re.sub(r'(<[^<>]*>)','',a)
                    a=re.sub(r'[\r\n]+','',a)
                    a=re.sub(r' ','',a)
                    a=a.replace('&nbsp;','')
                aa=aa+[a]
                a=html.readline()
                while a=="":a=html.readline()
            aaa=aaa+[aa]
        else:a=html.readline()
    html.close()
    return aaa,url

def getUrl(keyword):
    """
    根据关键字组成搜索url
    """
    return url0+urllib2.quote(keyword.decode(localcoding).encode(webcoding))

def parseUrl(url):
    """
    根据搜索到的mp3列表中的歌名链接获取下载地址
    注：此函数由xiooli <xioooli[at]yahoocomcn>在08.11.17修改
    以解开baidu对歌曲url的加密。参考了fengzishaoye的帖子：
    http://forum.ubuntu.org.cn/viewtopic.php?f=21&t=160965
    在此感谢。
    """
    url = url.replace(' ', '%20')
    f=urllib2.urlopen(url)
    a=f.read()
    f.close()
    b=re.findall(r'I=.*,J=',a)[0]
    b=re.sub(r'I=\"|\",J=','',b)
    if b[3]==":":
        key="fghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
    elif b[4]==":":
        key="hijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefg"
    else:
        pass
    KEY="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    tmpstr=re.split(b[0],KEY)
    urlQue=b[0]+tmpstr[1]+tmpstr[0]
    cmd="echo -n "+b+"|tr "+"\""+urlQue+"\" "+"\""+key+"\""
    realurl=os.popen(cmd).readline()
    return realurl
