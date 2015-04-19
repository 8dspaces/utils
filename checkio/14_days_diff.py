# know datetime module, know date class 
# timedelta.days 

import datetime

def days_diff(begin, end):
    d1 = datetime.date(*begin)
    d2 = datetime.date(*end)
    return abs((d2 - d1).days)

    
if __name__ == "__main__":
    assert days_diff((1982, 4, 19), (1982, 4, 22)) == 3
    assert days_diff((2014, 1, 1), (2014, 8, 27)) == 238
    assert days_diff((2014, 8, 27), (2014, 1, 1)) == 238