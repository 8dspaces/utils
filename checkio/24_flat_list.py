def flat_list_2(data):
    result = []
    def flat(data):
        while data:
            i = data.pop(0)
            if not isinstance(i, iters):
                result.append(i)
            else:
                flat(i)
    flat(data)
    return result
    
def flat_list_3(data):
    r=[]
    while data:
        i = data.pop(0)
        if not isinstance(i, list):
            r.append(i)
        else:
            flat_list(i, r)
    return r  
    
def flat_list(d):
    d = str(d).replace('[','').replace(']','').replace(',',' ').split()
    return map(int, d) if d else []   

def flat_list_1(a):
    t = []
    for i in a:
        if isinstance(i, list):
            t += flat_list(i)
        else:
            t.append(i)
    return t   
# reference     
flat_list_5=lambda L: sum(map(flat_list,L),[]) if isinstance(L,list) else [L]

def flat_list_4(l):
    r = []
    def f(l):
        for i in l:
            r.append(i) if type(i) is int else f(i)
    f(l)
    return r
print flat_list([1, 2, 3]) == [1, 2, 3]
print flat_list([1, [2, 2, 2], 4]) == [1, 2, 2, 2, 4]
print flat_list([[[2]], [4, [5, 6, [6], 6, 6, 6], 7]]) == [2, 4, 5, 6, 6, 6, 6, 6, 7]
print flat_list([-1, [1, [-2], 1], -1]) == [-1,1,-2,1,-1]
print flat_list([-1,[1,[-2,[3],[[5],[10,-11],[1,100,[-1000,[5000]]],[20,-10,[[[]]]]]]]])
print flat_list([])   



# one level list 
import itertools
list2d = [[1,2,3],[4,5,6], [7], [8,9]]
merged = list(itertools.chain(*list2d))
print merged
