# this is for checkio exercise 01


def solution_1(lst):
    dic = {}
    for i in lst:
        dic[i] = dic.get(i, 0) + 1
    
    lst_return = []
    for j in lst:
        if dic[j] > 1:
            lst_return.append(j)
        
    return lst_return
    
def solution_2(lst):
    lst_return = []
    # pop(0) is O(N) as all the items must be shifted. pop() however, 
    # is known to be a very fast operation as it removes an item from 
    # the end of the list,
    while lst:
        i = lst.pop()
        if i in lst or i in lst_return:
            lst_return.append(i)
    return lst_return[::-1]
    
remove_noise = solution_2 

if __name__ == "__main__":
    
    print remove_noise([1, 2, 3, 1, 3]) == [1, 3, 1, 3]
    print remove_noise([1, 2, 3, 4, 5]) == []
    print remove_noise([5, 5, 5, 5, 5]) == [5, 5, 5, 5, 5]
    print remove_noise([10, 9, 10, 10, 9, 8]) == [10, 9, 10, 10, 9]