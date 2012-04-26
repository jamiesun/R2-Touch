import QtQuick 1.0
import "json2.js" as Json
import "http.js" as Http
import "dbutils.js" as Dbm
ListModel{
    id:rssModel
    property string sid:main.sid
    property string auth:main.auth
    property string tag:""
    property string tagid:""
    property string source: "https://www.google.com/reader/api/0/subscription/list"
    property string contentSource: "https://www.google.com/reader/api/0/stream/contents/"


    property bool busy: false
    signal message(string msg)



    function onError(err){
        message(err)
        busy = false
    }

    function loadCache(tag,tagid){
        rssModel.tag = tag
        rssModel.tagid = tagid
        var cbk = function(rssdata){
            if(!rssdata)
                update(tag)
            else{
                onData(rssdata)
            }
        }
        Dbm.querySubs(tag,cbk)
    }

    function onData(result){
        busy = false
        rssModel.clear()
        for(var i=0;i<result.length;i++){
            var rss = result[i]
            var categories = rss.categories
            rssModel.append({feedtitle:rss.title,feedid:rss.id})
        }
        rssModel.insert(0,{feedtitle:"All items",feedid:tagid})
    }



    function update(tag,tagid){
        //if(main.rssLast)return
        if(!sid||!auth){
            message("not login")
            return;
        }
        Dbm.log_info("update rss for tag "+tag)
        rssModel.tag = tag
        rssModel.tagid = tagid
        var params = {
            output:"json",
            auth:auth,
            sid:sid
        }
        busy = true

        var cbk = function(rdata){
            var result = JSON.parse(rdata)['subscriptions']
            Dbm.updateSubs(result)
            Dbm.querySubs(tagid,onData)
        }
        Http.doGet(source,params,cbk,onError)

    }
}
