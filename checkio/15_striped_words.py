"""
The alphabet contains both vowel and consonant letters 
(yes, we divide the letters).
Vowels -- A E I O U Y
Consonants -- B C D F G H J K L M N P Q R S T V W X Z

You are given a block of text with different words. These 
words are separated by white-spaces and punctuation marks. 
Numbers are not considered words in this mission (a mix of 
letters and digits is not a word either). You should count 
the number of words (striped words) where the vowels with 
consonants are alternating, that is; words that you count 
cannot have two consecutive vowels or consonants. The words
 consisting of a single letter are not striped -- do not 
 count those. Casing is not significant for this mission.
"""
import re 

def striped_words(words):
    vowels= set('aeiouy')
    consonants=set('bcdfghjklmnpqrstvwxz')
    all = vowels|consonants
    
    count = 0
    words = re.sub("\W",' ',words).lower()
    for word in re.split("[\s]+",words):
        if len(word)>1 and set(word) <= all:
            
            l = word[::2]
            r = word[1::2]
            if len(set(l) & vowels) == 0 and len(set(r)&consonants) == 0: 
                count += 1
            elif len(set(r) & vowels)==0 and len(set(l)&consonants)==0:
                count += 1
    return count 
# reference 

def checkio_2(text):
    text = text.upper()
    for c in PUNCTUATION:
        text = text.replace( c, " " )
    for c in VOWELS:
        text = text.replace( c, "v" )
    for c in CONSONANTS:
        text = text.replace( c, "c" )

    words = text.split( " " )
    
    count = 0
    for word in words:
        if len( word ) > 1 and word.isalpha():
            if word.find( "cc" ) == -1 and word.find( "vv" ) == -1:
                count += 1

    return count

    
checkio = striped_words
if __name__ == '__main__':
    assert checkio("My name is ...") == 3
    assert checkio("Hello world") == 0
    assert checkio("A quantity of striped words.") == 1, "Only of"
    assert checkio("Dog,cat,mouse,bird.Human.") == 3
    assert checkio("To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it?") == 8
