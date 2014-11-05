def check_brackets(formula):
    brackets = {'(' : ')','[' : ']','{' : '}'}
    left = []
    right = []
    for i in formula: 
        if i in brackets.keys():
            left.append(i)
            flag = True
        elif i in brackets.values():
            if left and brackets[left[-1]] == i and flag:
                    left.pop()
                    flag = True 
                    continue 
            right.append(i)
            flag = False 

    if len(left) != len(right):
        return False 
    while left:
        if brackets[left.pop()] != right.pop(0):
            return False 
    return True 

checkio = check_brackets

# reference 
"""Check for proper bracket nesting."""

BRACKET_PAIRS = ['()', '{}', '[]', '<>']
OPEN_BRACKETS = {a for a, _ in BRACKET_PAIRS}
CLOSE_BRACKETS = {b: a for a, b in BRACKET_PAIRS}

def checkio_2(text):
    """Return whether text has proper bracket nesting."""
    stack = []
    for c in text:
        if c in OPEN_BRACKETS:
            stack.append(c)
        elif c in CLOSE_BRACKETS:
            if not stack or stack[-1] != CLOSE_BRACKETS[c]:
                return False
            stack.pop()

    return not stack
    
def checkio_3(data):
    stack=[""]
    brackets={"(":")","[":"]","{":"}"}
    for c in data:
        if c in brackets:
            stack.append(brackets[c])
        elif c in brackets.values() and c!=stack.pop():
            return False
    return stack==[""]
    
if __name__ == '__main__':
    
    assert checkio("((5+3)*2+1)") == True
    assert checkio("{[(3+1)+2]+}") == True
    assert checkio("(3+{1-1)}") == False
    assert checkio("[1+1]+(2*2)-{3/3}") == True
    assert checkio("(({[(((1)-2)+3)-3]/3}-3)") == False
    assert checkio("2+3") == True 
    assert checkio("(((1+(1+1))))]") == False 
