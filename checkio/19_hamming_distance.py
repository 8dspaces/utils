def hamming_distance(n, m):
    n = bin(n)[2:]
    m = bin(m)[2:]
    if len(m)>len(n):
        n=(len(m)-len(n))*'0' + n
    else:
        m=(len(n)-len(m))*'0' + m
    return sum(map(lambda x:1 if x[0]!=x[1] else 0, zip(n,m)))

# reference 
def checkio_2(n, m):
    return bin(n ^ m).count('1')

checkio_3 = lambda n, m: format(n ^ m, 'b').count('1')

    
checkio = hamming_distance
if __name__ == '__main__':
    
    assert checkio(117, 17) == 3
    assert checkio(1, 2) == 2
    assert checkio(16, 15) == 5
    