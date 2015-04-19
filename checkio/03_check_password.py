# coding: utf-8
"""
斯蒂芬和索菲亚对于一切都使用简单的密码，忘记了安全性。
请你帮助尼古拉开发一个密码安全检查模块。如果密码的长度
大于或等于10个符号，至少有一个数字，一个大写字母和一个
小写字母，该密码将被视为足够强大。密码只包含ASCII拉丁
字母或数字。

"""
import re 

def check_password(data):
    if (
       len(data) >= 10 
       and re.search("[0-9]+", data) 
       and re.search("[a-z]+", data) 
       and re.search("[A-Z]+", data)
       ):
        return True 
    else:
        return False
checkio = check_password


#  一个参考解法 

def checkio_2(psswd):
    # return True only if all of the following are True:
    # length of psswd is >= 10 chars
    # psswd is not all lowercase (conatins 1 or more uppercase)
    # psswd is not all uppercase (contains 1 or more lowercase)
    # psswd is not all alphanumeric (conatins 1 or more numbers)
    # psswd is not all numbers (conatins 1 or more alphanumerics)
    return ( (len(psswd) >= 10) and 
             (not psswd.islower()) and 
             (not psswd.isupper()) and 
	         (not psswd.isalpha()) and
             (not psswd.isdigit()))
             
if __name__ == '__main__':        
    assert checkio('A1213pokl') == False
    assert checkio('bAse730onE') == True
    assert checkio('asasasasasasasaas') == False
    assert checkio('QWERTYqwerty') == False
    assert checkio('123456123456') == False
    assert checkio('QwErTy911poqqqq') == True 
    
    