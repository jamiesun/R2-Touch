//Qt.include("dbutils.js")
WorkerScript.onMessage = function(message) {
    //console.log("logging action")
    var userid = message.user

    var cbk = function(logs){
        for(var idx in logs){
            var log = logs[idx]
            var params = "userid="+encodeURIComponent(userid)+"&desc="+ encodeURIComponent(log.desc)+"&datetime="+encodeURIComponent(log.datetime)
            //console.log(params)
            var http = new XMLHttpRequest();
            http.onreadystatechange = function() {
                if (http.readyState == XMLHttpRequest.DONE) {
                    //console.log("logging action"+ http.status+"  "+http.statusText);
                    if(http.status==200){
                        WorkerScript.sendMessage({code:0,logid:log.id});
                    }
                }
            }
            var url = "http://r2stat.sinaapp.com/r2log.php"
            http.open("POST",url);
            http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            http.setRequestHeader("Content-Length", params.length);
            http.send(params)

        }
    }

    queryLogs(cbk)

}
