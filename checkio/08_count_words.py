# coding: utf-8 

def count_words(text, words):
    text = text.lower()
    result = 0
    for word in words:
        if text.find(word) >= 0:
            result += 1
    return result 
    
    
if __name__ == '__main__':
    
    assert count_words("How aresjfhdskfhskd you?", {"how", "are", "you", "hello"}) == 3
    assert count_words("Bananas, give me bananas!!!", {"banana", "bananas"}) == 2
    assert count_words("Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
            {"sum", "hamlet", "infinity", "anything"}) == 1