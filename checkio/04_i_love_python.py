# coding: utf-8

def i_love_python():
    """
        Let's explain why do we love Python.
    """
    python = ['power', 'simple', 'fun','more']
    if ('simple' in python and 
        'power' in python and 
        'fun' in python and 
        'more' in python
        ):
        return "I love Python!"
    else:
        return "I hate Python!"
        
if __name__ == '__main__':
    #These "asserts" using only for self-checking and not necessary for auto-testing
    assert i_love_python() == "I love Python!"

# 参考答案
def i_love_python(complaints='', impossibles={}, reasons=None, love=True):
    return 'I love Python!'     