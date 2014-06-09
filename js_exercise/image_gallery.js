//Create simple image gallery
(function(){
    var images = [],
        target_image = document.getElementById("t_img"),
        current = 0,
        next = document.getElementById("next"),
        interval;
        
    images[0] = "C:\\Users\\Public\\Pictures\\Sample Pictures\\Jellyfish.jpg";
    images[1] = "C:\\Users\\Public\\Pictures\\Sample Pictures\\Desert.jpg";
    images[2] = "C:\\Users\\Public\\Pictures\\Sample Pictures\\Tulips.jpg";
    
    target_image.src = images[current];
    function next_handle(){
        if(current < images.length){
            target_image.src = images[current];
            current += 1;
        }
        else{
            current = 0;
            target_image.src = images[current];
        }
        
    }
    function pre_handle(){
        if(current > 0){
            target_image.src = images[current];
            current -= 1;
        }
        else{
            current = 2;
            target_image.src = images[current];
        }
    }
    function auto(){
        if(current < images.length){
            target_image.src = images[current];
            current += 1;
        }
        else{
            current = 0;
            target_image.src = images[current];
        } 
        interval = setInterval("auto()",2000);        
    }
    
    
    window.onload = auto;
    next.onclick = next_handle;
    pre.onclick = pre_handle;
})();
