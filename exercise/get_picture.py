'''
Created on 2009-8-17
 
@author: lign
 
'''
import os
import sys
import random
import urllib
import win32gui
import win32con
from PIL import Image
 
class StealBing:
 
    def __init__(self):
        self.content = urllib.urlopen('http://www.bing.com/').read()
        self.bgImageUrl = ''
        self.localFileName = ''
        self.localBMPFileName = ''
         
    def parserImageURL(self):
        tempStr = self.content[self.content.index('g_img={url:')+12:len(self.content)]
        tempStr = tempStr[0:tempStr.index(',id:')-1]
        tempStr = tempStr.replace('\\', '')
        self.bgImageUrl = 'http://cn.bing.com'+tempStr
         
    #Only for local File Path
    def createLocalFileName(self):  
        randomStr = ''.join(random.sample(['a','b','c','d','e','f','g','h','i','j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'], 6)).replace(" ","")
        self.localFileName =  'c:/temp/Img/' + randomStr + '.jpg'
        self.localBMPFileName = 'c:/temp/Img/' + randomStr + '.bmp'
     
    def downloadImage(self):
        if self.bgImageUrl == '':
            self.parserImageURL()
        if self.localFileName == '':
            self.createLocalFileName()
             
        data = urllib.urlretrieve(self.bgImageUrl, self.localFileName) 
         
    def updataBGImage(self):
        img = Image.open(self.localFileName)
        img.save(self.localBMPFileName)
        os.remove(self.localFileName)
        win32gui.SystemParametersInfo(win32con.SPI_SETDESKWALLPAPER, self.localBMPFileName , 0)
         
if __name__ == '__main__':
    stealBing = StealBing()
    stealBing.downloadImage()
    stealBing.updataBGImage()
 
