def binary_count(int):
    return str(bin(int)).count('1')
    
checkio = binary_count 
    
if __name__ == '__main__':
    assert checkio(4) == 1
    assert checkio(15) == 4
    assert checkio(1) == 1
    assert checkio(1022) == 9