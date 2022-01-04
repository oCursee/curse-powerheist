$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
   
    $("#close").click(function () {
        $.post('http://curse-powerheist/exit', JSON.stringify({}));
        return
    })
   
    $("#submit").click(function () {
        let inputVal = document.getElementById('inputField').value
       if (inputVal == 1513212812){
        $.post('http://curse-powerheist/startExtract', JSON.stringify({}));
       }else {
        $.post('http://curse-powerheist/wrongPassword', JSON.stringify({}));
       }
    })
})


$(function () {
    function display2(bool) {
        if (bool) {
            $("#container2").show();
        } else {
            $("#container2").hide();
        }
    }

    display2(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui2") {
            if (item.status == true) {
                display2(true)
            } else {
                display2(false)
            }
        }
    })
   
    var slider = document.getElementById("myRange");
    var output = document.getElementById("data1");
    output.innerHTML = slider.value; 

    
    slider.oninput = function() {
     output.innerHTML = this.value;
    }
    var slider2 = document.getElementById("myRange2");
    var output2 = document.getElementById("data2");
    output2.innerHTML = slider2.value; 

    
    slider2.oninput = function() {
     output2.innerHTML = this.value;
    }
    var slider3 = document.getElementById("myRange3");
    var output3 = document.getElementById("data3");
    output3.innerHTML = slider3.value; 

    
    slider3.oninput = function() {
     output3.innerHTML = this.value;
    }

    $("#submitSlider").click(function () {
      
        if (slider.value ==5 && slider2.value == 1 && slider3.value == 3){
            $.post('https://curse-powerheist/slideCorrect', JSON.stringify({}));
       }else {
        $.post('http://curse-powerheist/wrongPassword', JSON.stringify({}));
       }
    })

    
})