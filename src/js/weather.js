.pragma library

var weather_api = {};
weather_api.input = {
    "appid": "5066",
    "sign": "d7fcfe14b71b4689b3769fc908f950c8",
    "city": "成都",
    "timestamp": "",
};

weather_api.value = {};

weather_api.get_time = function(){
    var that = this;
    var date=new Date();
    var y = date.getFullYear();
    var m = date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1
    var d = date.getDate() < 10 ? '0'+date.getDate() : date.getDate();
    var h = date.getHours() < 10 ? '0'+date.getHours() : date.getHours();
    var min = date.getMinutes() < 10 ? '0'+date.getMinutes() : date.getMinutes();
    var sec = date.getSeconds() < 10 ? '0'+date.getSeconds() : date.getSeconds();
    that.input.timestamp = y.toString()+m.toString()+d.toString()+h.toString()+min.toString()+sec.toString();
}

weather_api.get_weather = function (callback){
    var that = this;
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            var object = JSON.parse(xhr.responseText.toString());
            print(xhr.responseText);
            that.value = object;
            if(callback && typeof(callback) === "function") callback();
        }
    }
    weather_api.get_time();
    var send_data =  "https://route.showapi.com/9-2?area=" + weather_api.input.city + "&areaid=&needIndex=1&needMoreDay=0&showapi_appid=" + weather_api.input.appid + "&showapi_timestamp=" + weather_api.input.timestamp + "&showapi_sign=" + weather_api.input.sign;
    print(send_data);
    xhr.open("GET",send_data);
    xhr.send();
}

function func() {

}

