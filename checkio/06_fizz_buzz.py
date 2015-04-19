# coding: utf-8 
"""
You should write a function that will receive a positive integer and return:
"Fizz Buzz" if the number is divisible by 3 and by 5;
"Fizz" if the number is divisible by 3;
"Buzz" if the number is divisible by 5; 
The number as a string for other cases.
"""

def fizz_buzz(i):
    
    if i%15 == 0:
        return "Fizz Buzz"
    elif i % 3 == 0:
        return "Fizz"
    elif i % 5 == 0:
        return "Buzz"
    else:
        return str(i)


checkio = fizz_buzz
    
if __name__ == '__main__':
    assert checkio(15) == "Fizz Buzz"
    assert checkio(6) == "Fizz"
    assert checkio(5) == "Buzz"
    assert checkio(7) == "7"