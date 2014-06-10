<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<input type="button" value="Change Color" id="bg"/>
    <input type="button" value="numbers" id="num"/>
    <div>
    <p>Current Time: </p>
    <p id="time"></p>
    </div>
    <script type="text/javascript">
        function changecolor(){
            var colors = ['white','red','blue','yellow','green'],
                random_color;
            random_color = colors[Math.round(Math.random()*colors.length)];
            
            body = document.getElementsByTagName("body")[0];
            //body.style.color = "red";
            body.style.backgroundColor = random_color; //"blue";
        }
        var  element1 = document.getElementById("bg");
        element1.onclick = changecolor;  
        
        function shownumbers(){
           var i=1;
           var count = 0
           while(i < 1000){
                if(i%3 == 0 && i%5 == 0 && i%7 ==0){ 
                
                    if(count && count%6 == 0){
                        document.write("<br/>");
                    } 
                    count += 1
                    document.write(i + "  ");   
                }
                i = i + 1;
           }
        
        }
        var  element2 = document.getElementById("num");
        element2.onclick = shownumbers; 

        var  element3 = document.getElementById("time");
        function updatetime(){

            d = new Date();
            element3.innerHTML = d;
            
        }
        var t = setInterval("updatetime()", 500); 
    </script>
</body>
</html>
