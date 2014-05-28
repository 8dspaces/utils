def perm(seq, l=None):
      if l is None:
           l = len(seq)
      for i in range(len(seq)):
           c  = seq[i:i+1]
           if l == 1:
                 yield c
           else:
                 rest = seq[:i] + seq[i+1:]
                 for each in perm(rest, l-1):
                                     yield  c + each
 
def main(seq):
     for i in perm(seq):
         print i

def test_1():
	
	for i in range(1234, 4322):
		if set(str(i)) == set(str(1234)):
			print i

def test_2(n):
	base = ['a' for _ in range(8)]
	output = []
	i = len(base) -1
	
	while n > 0:			
		
		output.append("".join(base))
		base[i] = chr(ord(base[i])+1)
		
		while base[i] > 'z':
			base[i] = 'a'
			i = i-1
			base[i] = chr(ord(base[i])+1)
		i = len(base) -1
		
		n = n-1
	return output
	
if __name__ == '__main__':
     #main('123')
	 #test_1()
	 #print test_2(40)
	 for i in perm("ABCD"):
		print i
