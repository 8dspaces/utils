def three_words(words):
    import re 
    if re.search("[a-zA-Z]+ [a-zA-Z]+ [a-zA-Z]+", words):  
        return True
    return False 
    
checkio = three_words

# reference 

def checkio_2(words):
    succ = 0
    for word in words.split():
        succ = (succ + 1)*word.isalpha()
        if succ == 3: return True
    else: return False
    
if __name__ == "__main__":
    assert checkio("Hello World hello") == True
    assert checkio("He is 123 man") == False
    assert checkio("1 2 3 4") == False
    assert checkio("bla bla bla bla") == True
    assert checkio("Hi") == False
    