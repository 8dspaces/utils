import re 
def total_cost(bill):
    result = 0
    cost = {}
    for i in bill:
        match = re.search(r'(\d{4}-\d{2}-\d{2}) \d{2}:\d{2}:\d{2} (\d+)', i)
        minutes = (int(match.group(2))+59) //60 
        cost[match.group(1)] = cost.get(match.group(1),0) + minutes 
    
    for time in cost.values():
        if time > 100:
            result += (time-100) * 2 + 100
        else:
            result += time
        
        
    return result 

# reference 

from collections import Counter

def total_cost_2(calls):
    db = Counter()
    for call in calls:
        day, time, duration = call.split()
        db[day] += (int(duration) + 59) // 60
    return sum(min if min < 100 else 2*min-100 for min in db.values())
    
if __name__ == '__main__':
    assert total_cost(("2014-01-01 01:12:13 181",
            "2014-01-02 20:11:10 600",
            "2014-01-03 01:12:13 6009",
            "2014-01-03 12:13:55 200")) == 124
        