function doGet(url,params,sucess,error){
    var auth = params.auth
    var sid = params.sid
    var paramStr = parseParams(params)
    console.log(url+"?"+paramStr)

    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            if(http.status==200){
                sucess(http.responseText)
            } else{
                error("error:"+http.statusText)
            }
        }
    }
    http.open("GET", url+"?"+paramStr)
    http.setRequestHeader("Authorization","GoogleLogin auth="+auth);
    http.setRequestHeader("Cookie","SID="+sid);
    http.setRequestHeader("accept-encoding", "gzip, deflate")
    http.send()
}


function doPost(url,params,sucess,error){
    var auth = params.auth
    var sid = params.sid
    var paramStr = parseParams(params)

    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            if(http.status==200){
                sucess(http.responseText)
            } else{
                error(http.statusText)
            }
        }
    }
    http.open("GET", url)
    http.setRequestHeader("Authorization","GoogleLogin auth="+auth);
    http.setRequestHeader("Cookie","SID="+sid);
    http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    http.setRequestHeader("Content-Length", paramStr.length);
    http.send(paramStr)
}

function parseParams(paramData){
    var paramStr = ""
    for(var key in paramData){
        if(key!="auth"&&key!="sid"){
            paramStr += (key+"="+paramData[key]+"&")
        }
    }
    if(paramStr)
        paramStr = paramStr.substring(0,paramStr.length-1)

    return paramStr;
}
