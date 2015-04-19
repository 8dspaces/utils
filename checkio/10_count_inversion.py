# coding: utf-8 

"""
In computer science and discrete mathematics, an inversion is
 a pair of places in a sequence where the elements in these 
 places are out of their natural order. So, if we use ascending
 order for a group of numbers, then an inversion is when larger 
 numbers appear before lower number in a sequence.

Check out this example sequence: (1, 2, 5, 3, 4, 7, 6) and 
we can see here three inversions
- 5 and 3; - 5 and 4; - 7 and 6.
"""

def count_inversion(seq):
    
    count = 0
    for i in range(len(seq)):
        for j in seq[i+1:]:
            if seq[i] > j:
                count += 1
                
    return count 

# reference: use enumerate
def count_inversion_1(sequence):
    return sum(sum(m<n for m in sequence[i+1:]) for i,n in enumerate(sequence))
    
if __name__ == "__main__":
    
    assert count_inversion((1, 2, 5, 3, 4, 7, 6)) == 3
    assert count_inversion((0, 1, 2, 3)) == 0
            
    