def clock_angle_2(time):
    hour, mins = map(float, time.split(':'))
    hour= hour if hour<12 else hour-12 
    hour= (hour+ mins/60)/12 * 360 # = 30*hour + 0.5*mins 
    mins = mins/60 * 360 
    
    print hour, mins
    
    angle = abs(hour-mins)
    return angle if angle<=180 else 360-angle 

# reference 
def clock_angle(time):
    hour, minutes = map(int, time.split(':'))
    angle = abs(30 * (hour % 12) - 5.5 * minutes)
    return min(angle, 360 - angle)
    
if __name__ == '__main__':
    assert clock_angle("02:30") == 105
    assert clock_angle("13:42") == 159
    assert clock_angle("01:43") == 153.5