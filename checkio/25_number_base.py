def number_base(number, radix):
    
    dic = dict(zip('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',range(36)))
    result = 0
    number = list(number)
    for j in range(len(number)):
        i = dic.get(number.pop())
        if i < radix:
            result += (i * (radix**j))
        else:
            return -1
            
    return result 
    
def checkio(*a):
    try: return int(*a)
    except ValueError: return -1
    
#checkio = number_base

if __name__ == '__main__':
    assert checkio("AF", 16) == 175
    assert checkio("101", 2) == 5
    assert checkio("101", 5) == 26
    assert checkio("Z", 36) == 35
    assert checkio("AB", 10) == -1