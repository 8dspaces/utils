# coding: utf-8

"""
给你一个其中包含不同的英文字母和标点符号的文本，
你要找到其中出现最多的字母，返回的字母必须是小写形式，
当检查最想要的字母时，不区分大小写，所以在你的搜索中
 "A" == "a"。 请确保你不计算标点符号，数字和空格，只计算字母。

如果你找到 两个或两个以上的具有相同的频率的字母，
 返回那个先出现在字母表中的字母。 例如 -- “one”包含“o”，
 “n”，“e”每个字母一次，因此我们选择“e”. 
"""

def find_most(data):
    data = data.lower()
    
    dic = {}
    for i in data:
        if i.isalpha():
            dic[i] = dic.get(i, 0) + 1
    for j in sorted(dic.keys()): 
        if dic[j] == max(dic.values()):
            return j
    
checkio = find_most

## 参考答案

import string

def checkio_2(text):
    """
    We iterate through latyn alphabet and count each letter in the text.
    Then 'max' selects the most frequent letter.
    For the case when we have several equal letter,
    'max' selects the first from they.
    """
    text = text.lower()
    return max(string.ascii_lowercase, key=text.count)

def checkio_3(text):
    letters = "abcdefghijklmnopqrstuvwxyz"
    wanted_letter = ""
    most_times = 0
    for letter in letters:
        times = 0
        for char in text:
            if (char.lower()) == letter:
                times += 1
        if (most_times == times):
            if (wanted_letter > letter):
                wanted_letter = letter
        elif (most_times < times):
            most_times = times
            wanted_letter = letter
    return wanted_letter
    
def checkio_3 (text):
    text = text.lower()
    ans = ''
    max = 0
    for c in text:
        if not c.isalpha():
            continue
        if ans == '' or text.count(c) > max or (text.count(c) == max and c < ans):
            ans = c
            max = text.count(c)
    return ans
    
if __name__ == '__main__':

    assert checkio("Hello World!") == "l"
    assert checkio("How do you do?") == "o"
    assert checkio("One") == "e"
    assert checkio("Oops!") == "o"
    assert checkio("AAaooo!!!!") == "a"
    assert checkio("abe") == "a"
    