"""
The array (a tuple) has various numbers. You should 
sort it, but sort it by absolute value in ascending 
order. For example, the sequence (-20, -5, 10, 15) 
will be sorted like so: (-5, 10, 15, -20). 
Your function should return the sorted list or tuple
"""

def absolute_sort(seq):
    
    return sorted(seq, key = abs)
    
checkio = absolute_sort

if __name__ == "__main__":
    
    assert checkio((-20, -5, 10, 15)) == [-5, 10, 15, -20] # or (-5, 10, 15, -20)
    assert checkio((1, 2, 3, 0)) == [0, 1, 2, 3]
    assert checkio((-1, -2, -3, 0)) == [0, -1, -2, -3]