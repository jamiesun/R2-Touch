WorkerScript.onMessage = function(message) {
    var auth = message.auth
    var sid = message.sid
    var token = message.token
    var action = message.action?"a":"r"
    var option = message.option
    var entry = message.id
    var streamId = message.streamId



    var params = "T="+token+"&"+action+"="+"user/-/state/com.google/"+option+"&ac=edit-tags&i="+entry+"&s="+streamId


    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            if(http.status==200){
               WorkerScript.sendMessage({code:0})
            }else if(http.status==401){
                WorkerScript.sendMessage({code:401})
            }
        }
    }
    var url = "https://www.google.com/reader/api/0/edit-tag?client=scroll"
    http.open("POST",url);
    http.setRequestHeader("Authorization","GoogleLogin auth="+auth);
    http.setRequestHeader("Cookie","SID="+sid);
    http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    http.setRequestHeader("Content-Length", params.length);
    http.send(params)


}








