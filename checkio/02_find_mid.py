def find_mid(ls):
    
    length = len(ls)
    ls.sort()
    if length%2 != 0:
        return ls[length/2]
    else:
        return (ls[length/2-1] + ls[length/2])/ 2.0

checkio = find_mid

if __name__ == '__main__':
    assert checkio([1, 2, 3, 4, 5]) == 3
    assert checkio([3, 1, 2, 5, 3]) == 3
    assert checkio([1, 300, 2, 200, 1]) == 2
    assert checkio([3, 6, 20, 99, 10, 15]) == 12.5