#coding: utf-8 

"""
You are given an array with positive numbers and a number N. 
You should find the N-th power of the element in the array 
with the index N. If N is outside of the array, then return -1. 
Don't forget that the first element has the index 0.

Let's look at a few examples::
- array = [1, 2, 3, 4] and N = 2, then the result is 32 == 9;
- array = [1, 2, 3] and N = 3, but N is outside of the array, so the result is -1.
"""

def index_power(ls, index):
    try:
        return ls[index]**2
    except IndexError:
        return -1 
    


if __name__ == '__main__':
    
    index_power([1, 2, 3, 4], 2) == 9
    index_power([1, 3, 10, 100], 3) == 1000000
    index_power([0, 1], 0) == 1
    index_power([1, 2], 3) == -1
    