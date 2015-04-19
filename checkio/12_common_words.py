"""
len(s)	 	cardinality of set s
x in s	 	test x for membership in s
x not in s	 	test x for non-membership in s
s.issubset(t)	s <= t	test whether every element in s is in t
s.issuperset(t)	s >= t	test whether every element in t is in s
s.union(t)	s | t	new set with elements from both s and t
s.intersection(t)	s & t	new set with elements common to s and t
s.difference(t)	s - t	new set with elements in s but not in t
s.symmetric_difference(t)	s ^ t	new set with elements in either s or t but not both
s.copy()	 	new set with a shallow copy of s
"""
def common_words(first, second):
    #first = set(first.split(','))
    #second = set(second.split(','))
    #return ','.join(sorted(list(first&second)))
    return ','.join(sorted(list(set(first.split(','))&set(second.split(','))))) 
checkio = common_words
    
if __name__ == "__main__":
    assert checkio(u"hello,world", u"hello,earth") == "hello"
    assert checkio(u"one,two,three", u"four,five,six") == ""
    assert checkio(u"one,two,three", u"four,five,one,two,six,three") == "one,three,two"