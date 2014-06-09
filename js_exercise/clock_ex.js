function clock_ex(){
    function Clock(){
        this.hours = 0;
        this.minutes = 0;
        this.seconds = 0;
    }
    Clock.prototype = {
        setTime: function(h,m,s){
            this.hours = h;
            this.minutes = m;
            this.seconds = s;
        },
        displayTime: function(format){
            if(typeof(format) == "string"){
                if(format == "a.m"){
                    alert("time is:" + this.hours + ":" + this.minutes + ":" + this.seconds + " A.M");
                }
                else if(format == "p.m"){
                    alert("time is:" + (Number(this.hours)>12? this.hours-12: this.hours) + ":" + this.minutes + ":" + this.seconds + " P.M");
                }
            }
        }
    };
    c = new Clock();
    c.setTime(15,15,20);
    c.displayTime("a.m");
    c.displayTime("p.m");
}
clock_ex();
