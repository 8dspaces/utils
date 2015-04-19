def the_end_other(data):
    if len(data) > 1:
        for i in data:
            for j in data-set(i): 
                if len(i) > len(j) and i[-len(j):] == j:
                    return True 
                if len(i) < len(j) and j[-len(i):] == i: 
                    return True 
    return False 
checkio = the_end_other
    
print checkio({"hello", "lo", "he"}) == True
print checkio({"hello", "la", "hellow", "cow"}) == False
print checkio({"walk", "duckwalk"}) == True
print checkio({"one"}) == False
print checkio({"helicopter", "li", "he"}) == False