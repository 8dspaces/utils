# coding: utf-8

'''
You are given an array of integers. You should find
 the sum of the elements with even indexes (0th, 2nd, 
 4th...) then multiply this summed number and the 
 final element of the array together. Don't forget 
 that the first element has an index of 0.

For an empty array, the result will always be 0 (zero).

'''

def even_the_last(data):
    l = len(data)
    if l:
        return sum([data[i] for i in range(l) if i%2 == 0])*data[l-1]
    return 0

# 参考答案

def checkio_2(array):
    """
        sums even-indexes elements and multiply at the last
    """
    if len(array) == 0: return 0
    return sum(array[0::2]) * array[-1]

checkio_3=lambda x: sum(x[::2])*x[-1] if x else 0    

checkio = even_the_last

if __name__ == "__main__":

    assert checkio([0, 1, 2, 3, 4, 5]) == 30
    assert checkio([1, 3, 5]) == 30
    assert checkio([6]) == 36
    assert checkio([]) == 0
    