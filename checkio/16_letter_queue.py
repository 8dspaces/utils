
class letter_queue():
    
    
    def __init__(self):

        self.letters = []
        
    def push(self, letter):
        self.letters.append(letter.upper())
        
    def pop(self):
        if self.letters:
            return self.letters.pop(0)
    
    def __call__(self,ops):

        for op in ops:
            op = op.split()
            if len(op)>1:
                getattr(self, op[0].lower())(op[1])
            else:
                getattr(self, op[0].lower())()
        re = "".join(self.letters)
        self.letters = []
        return re 
        
    
checkio = letter_queue()

# reference 
def letter_queue_2(commands):
    import collections
    queue = collections.deque()
    for command in commands:
        if command.startswith("PUSH"):
            queue.append(command[-1])
        elif queue:
            queue.popleft()            
    return "".join(queue)
    
def letter_queue_3(commands):
    stackList=[]
    for command in commands:
        if command.startswith("PUSH"):
            operator,operant=command.split()
        if command=="POP":
            operator="POP"
        if operator=='PUSH':
            stackList.append(operant)
        if operator=='POP':
            if stackList!=[]:
                stackList=stackList[1:]
    return ''.join(stackList)


if __name__ == "__main__":
    
    assert checkio(["PUSH A", "POP", "POP", "PUSH Z", "PUSH D", "PUSH O", "POP", "PUSH T"])== "DOT"
    assert checkio(["POP", "POP"]) == ""
    assert checkio(["PUSH H", "PUSH I"]) == "HI"
    assert checkio([]) == ""