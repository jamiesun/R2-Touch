WorkerScript.onMessage = function(message) {
    var auth = message.auth
    var status = encodeURIComponent(message.status)
    var source = "1411883587"
    var params = "source="+source+"&status="+status

    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            if(http.status==200){
                WorkerScript.sendMessage({code:0,msg:"ok"})
            }else{
                WorkerScript.sendMessage({code:1,msg:http.statusText})
            }
        }
    }
    var url = "http://api.t.sina.com.cn/statuses/update.xml"
    http.open("POST",url);
    http.setRequestHeader("Authorization","Basic "+ auth);
    http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    http.setRequestHeader("Content-Length", params.length);
    http.send(params)


}
