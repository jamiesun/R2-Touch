WorkerScript.onMessage = function(message) {
    var auth = message.auth
    var sid = message.sid
    var token = message.token
    var pu = encodeURIComponent("http://www.google.com/profiles/116061383341805397096")
    var params = "T="+token+"&action=addfollowing&pu="+pu+"&u=02968909773540115760"

    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            if(http.status==200){
                WorkerScript.sendMessage({code:0})
            }else{
                WorkerScript.sendMessage({code:1})
            }
        }
    }
    var url = "https://www.google.com/reader/api/0/friend/edit?client=scroll"
    http.open("POST",url);
    http.setRequestHeader("Authorization","GoogleLogin auth="+auth);
    http.setRequestHeader("Cookie","SID="+sid);
    http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    http.setRequestHeader("Content-Length", params.length);
    http.send(params)


}








