def check_brackets(formula):
    brackets = {'{' : '}','(' : ')','[' : ']'}
    left = []
    right = []
    for i in formula:
        if i in brackets.keys():
            left.append(i)
            flag = True 
        elif i in brackets.values():
        
            if brackets[left[-1]] == i:
                if flag:
                    left.pop()
                    flag = True
                else:
                    right.append(i)
                    falg = False 

    if len(left) != len(right):
        return False 
        
    while left:
        if brackets[left.pop()] != right.pop(0):
            return False 
    return True
checkio = check_brackets
    
if __name__ == '__main__':
    assert checkio("((5+3)*2+1)") == True
    assert checkio("{[(3+1)+2]+}") == True
    assert checkio("(3+{1-1)}") == False
    assert checkio("[1+1]+(2*2)-{3/3}") == True
    assert checkio("(({[(((1)-2)+3)-3]/3}-3)") == False 
