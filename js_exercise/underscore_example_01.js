## 关于underscore.js 的模块化

//### 简单化就是: 
/*(this) 是可以用于兼容不同的环境，客户端（Browser）this 是window 
  服务器端（node.js）this 代表global 
*/
(function() {})(this); 

//### 再加入一些细节
(function() {

  var root = this;
  // 用_ 代表全局变量，所有的功能都加载到这一对象
  
  var _  = {};
  root._ = _;

  _.VERSION = '1.6.0';
  
})(this);

// 将_ 指定到一个匿名函数

(function() {

  // Create a safe reference to the Underscore object for use below.
  var _ = function(obj) {
    if (obj instanceof _) return obj;
    if (!(this instanceof _)) return new _(obj);
    this._wrapped = obj;
  };
  
  var root = this;
  var _  = {};
  
  root._ = _;
  _.VERSION = '1.6.0';
  
  _.each = _.forEach = function(obj, iterator, context) {
   // Code here ...
  }
})(this);

