def ghost_age_2(units):
    base = 10000 
    age = 0 
    x, y = 1,1
    while base != units:
        base = base - y
        age += 1
        x, y = y, x+y
        for i in range(y-x-1):
            if base != units:
                base = base + 1
                age += 1
            else:
                return age 
                
    return age

def ghost_age(units):
    base = 10000 
    age = 0
    cache = []
    x, y = 1,1
    while True:
        cache.append(-y)
        x, y = y, x+y    
        for i in range(y-x-1):
            cache.append(1) 
        while cache:
            if base!= units:
                base += cache.pop(0)
                age += 1
            else:
                return age 
    
checkio = ghost_age 
print checkio(10000) == 0
print checkio(9999) == 1
print checkio(9997) == 2
print checkio(9994) == 3
print checkio(9995) == 4
print checkio(9990) == 5

# reference 
fibo = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946]

def checkio(opacity):
    cur_op = 10000
    age = 0
    while opacity != cur_op:
        age += 1
        if age in fibo:
            cur_op -= age
        else:
            cur_op += 1
    return age