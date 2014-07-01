<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<script type="text/javascript">

        function flttern(obj){
            var result = [];
            

            if(!isArray(obj)){
                return none;
            }
            else{
                _flat(obj);
                
            }
            return result;
            
            // real function to handle flat operation
            function _flat(arr){
                  for(var i=0; i<arr.length; i++){
                    if (isArray(arr[i])){
                        _flat(arr[i]);
                    }
                    else{
                        result.push(arr[i]);
                    }
                 }
            }
            function isArray(arr){
                return Object.prototype.toString.call(arr) == "[object Array]";
                //return Array.isArray(arr) Array新加的方法
            }
        }
    
    </script>
</body>
</html>
