def flat_list(data):
    return map(int, str(data).replace('[','').replace(']','').replace(' ', '').split(','))


def flat_list_1(a):
    t = []
    for i in a:
        if isinstance(i, list):
            t += flat_list(i)
        else:
            t.append(i)
    return t     


print flat_list([1, 2, 3]) == [1, 2, 3]
print flat_list([1, [2, 2, 2], 4]) == [1, 2, 2, 2, 4]
print flat_list([[[2]], [4, [5, 6, [6], 6, 6, 6], 7]]) == [2, 4, 5, 6, 6, 6, 6, 6, 7]
print flat_list([-1, [1, [-2], 1], -1]) == [-1,1,-2,1,-1]
