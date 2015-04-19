def restricted_sum(numbers):
    numbers = map(lambda x: x*'+' if x>0 else abs(x)*'-', numbers)
    return ''.join(numbers).count('+') - ''.join(numbers).count('-') 

checkio = restricted_sum
    
print checkio([1, 2, 3]) == 6
print checkio([2, 2, -2, 2, -2, 2]) == 4

# reference 
def checkio(data):
    if len(data)==0: return 0
    return data[0]+checkio(data[1:])
    
def checkio(data):
    d = map(str, data)
    return eval('+'.join(d))