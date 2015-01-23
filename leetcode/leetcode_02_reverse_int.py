# first solution is very ugly
class Solution:
    # @return an integer
    def reverse(self, x):
        x = list(str(x))
        x.reverse()
        x = ''.join(x)
        if x[-1] == '-':
            x = x[-1] + x[:-1]
        x = int(x)
        if abs(x) < 2147483647: 
        #if isinstance(x, int):
            return x
        else:
            return 0
    # A better one   
    def reverse(self, num):
      sign = 1
      if num < 0:
        sign = -1
      num = sign*int(str(num)[::-1])
      if isinstance(num, int):
        return num
      return 0
      
