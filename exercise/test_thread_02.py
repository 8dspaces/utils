import threading, time
lock = threading.Lock()

def set_worker(li):
	lock.acquire()
	for i in range(len(li)):
		li[i] = 1
		time.sleep(0.01)
	lock.release()
	
def print_worker(li):
	lock.acquire()
	for i in range(len(li)):
		print li[i]
		time.sleep(0.01)
	lock.release()
		
		
def test():
	li = [0]*20
	t1 = threading.Thread(target = set_worker, args = (li,))
	t2 = threading.Thread(target = print_worker, args = (li,))
	
	t1.start()
	t2.start()
	
	
test()
