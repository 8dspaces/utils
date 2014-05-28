import time
import sys
sys.setrecursionlimit(10000)

class quick_sort(object):
    
    def _quick_sort(self, alist, low, high):
        if low < high:
            key = self.findkey(alist,low,high)
            self._quick_sort(alist,low, key-1)
            self._quick_sort(alist,key+1, high)
            
    def findkey(self, alist, low, high):
        temp = alist[low]
        while low<high:
            while low<high and alist[high]>= temp:
                high -= 1
            alist[low] = alist[high]
            while low<high and alist[low]<= temp:
                low += 1
            alist[high] = alist[low]
        alist[low] = temp 
        return low
        
    def __call__(self,alist):
        self._quick_sort(alist, 0 , len(alist) -1)
        

class merge_sort(object):
    
    def _merge_sort(self, alist, low, high):
        if low < high:
            mid = (low+high)/2 
            self._merge_sort(alist,low, mid)
            self._merge_sort(alist,mid+1, high)
            self.merge(alist,low, high, mid)
            
    def merge(self, alist, low, high, mid):
        left = alist[low:mid+1]
        right = alist[mid+1:high+1]
        for i in range(low, high+1):
            if len(left)> 0  and len(right)> 0:
                if left[0] < right[0]:
                    alist[i] = left.pop(0)
                else:
                    alist[i] = right.pop(0)
            elif len(left) == 0:
                alist[i] = right.pop(0)
            elif len(right) == 0:
                alist[i] = left.pop(0)
                
    def __call__(self,alist):       
        self._merge_sort(alist, 0 , len(alist) -1)

if __name__ == '__main__':
    alist1 = range(1,1000)
    alist2 = range(1,1000)
    mysort1= quick_sort()
    mysort2= merge_sort()
    
    start_time = time.time()
    mysort1(alist1)
    used_time = time.time() - start_time
    print used_time
    
    start_time = time.time()
    mysort2(alist2)
    used_time = time.time() - start_time
    print used_time
    
    #print alist1
    #print alist2
