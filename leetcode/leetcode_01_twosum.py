# My Solution and it Time Limit Exceeded

"""
class Solution:
    # @return a tuple, (index1, index2)
    def twoSum(self, num, target):
        m = target- min(num)
        d = {i:j for i,j in enumerate(num,1) if j<= m}
        print d
        vs = d.values()
        t = 1
        for i, n in d.iteritems():
            if target-n in vs[t:]:
                return i, find_value(target-n, d, i)
            t += 1
            
def find_value(n, dic_num, e):
    for i, j in dic_num.iteritems():
        if j == n and i!=e:
            return i
            
""" 

# best solution 

def twoSum(self, nums, target):
    s = {}
    # second argument of enumerate indicates the starting index
    for i, num in enumerate(nums, 1):
        i1 = s.get(target-num)
        if i1 != None:
            # i1 should be smaller that i
            return i1, i
        else:
            s[num] = i
