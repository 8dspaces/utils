/*  Question 1: 
    给你一个字符串，寻找该字符串中出现次数最多的字母和出现次数。
    比如："aadfdfdfxcvbvbeeeessscv"
*/
function partition(str){
    var dic = {};
    for(var i=0; i<str.length; i++){
        dic[str[i]]?  dic[str[i]] += 1: dic[str[i]] = 1;
    }
    return dic;
}

a = "aadfdfdfxcvbvbeeeessscv";
b = partition(a);

/*  Question 2:
    对["a","b","c"]进行全排序。
*/
//可以穷举
function solution1(){

    var a = ['a','b','c'];
    
    for (var i = 3; i--;) {
        for (var j = 3; j --; ) {
                for (var k = 3; k --; ) {
                        if (a[i] !== a[j] && a[j] !== a[k] && a[i] !== a[k])
                                console.log(a[i] + a[j] + a[k])
                }
        }
    }
}


/*  
全排列（递归交换）算法  
1、将第一个位置分别放置各个不同的元素；  
2、对剩余的位置进行全排列（递归）；  
3、递归出口为只对一个元素进行全排列。  
*/ 
function swap(arr,i,j) {  
    if(i!=j) {  
        var temp=arr[i];  
        arr[i]=arr[j];  
        arr[j]=temp;  
    }  
}  
var count=0;  
function show(arr) {  
    document.write("P<sub>"+ ++count+"</sub>: "+arr+"<br />");  
}  
function perm(arr) {  
    (function fn(n) { //为第n个位置选择元素  
        for(var i=n;i<arr.length;i++) {  
            swap(arr,i,n);  
            if(n+1<arr.length-1) //判断数组中剩余的待全排列的元素是否大于1个  
                fn(n+1); //从第n+1个下标进行全排列  
            else 
                show(arr); //显示一组结果  
            swap(arr,i,n);  
        }  
    })(0);  
}  
perm(["a","b","c"]);  


/*  Question 3: 
    去掉数组中重复的元素；
*/
function remove_duplicate(arr){
    re = [];
    for(var i=0; i<arr.length; i++){
        if (re.indexOf(arr[i])=== -1){
            re.push(arr[i]);
        }
    }
    return re;
}
var a = ["abc", "abc", "a", "b", "c", "a", "b", "c"];
alert(remove_duplicate(a));


function remove_duplicate(arr){
    re = [];
}
/*
更好的解决办法
<html>
<head>
</head>
<body>
<script type="text/javascript">
Array.prototype.unique = function(){
        var hash = {},arr=[];
        for(var i = 0; i < this.length; i++){
                if (!hash[this[i]]){
                        hash[this[i]] = true;
                        arr.push(this[i]); 
                }
        }
        return arr;
};

//test
alert(['a','b','a','b','c','c'].unique());
</script>
<body></html>

*/
