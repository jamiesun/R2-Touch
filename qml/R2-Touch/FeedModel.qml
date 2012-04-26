import QtQuick 1.0
import "json2.js" as Json
import "http.js" as Http
import "dbutils.js" as Dbm
ListModel {
    id:feedModel
    property string sid:main.sid
    property string auth:main.auth
    property string token: main.token
    property string title:""
    property string feedid:""
    property string feedMax: main.feedMax
    property string contentSource: "https://www.google.com/reader/api/0/stream/contents/"
    property int page: 0
    property int total: 0

    property bool busy: false
    signal message(string msg)
    signal doContinuation(string c)

    function onError(err){
        message(err)
        busy = false
    }

    function onData(items,count){

        total = parseInt((count/20).toFixed(0))

        busy = false

        for(var i=0;i<items.length;i++){
            var mobj = {}
            mobj.content = items[i].summary.content || items[i].content.content
            mobj.title = items[i].title||(mobj.content.length>32?mobj.content.substring(0,32)+"...":mobj.content)
            mobj.id = items[i].id
            mobj.streamId =  items[i].origin.streamId
            mobj.srcUrl = items[i].origin.htmlUrl
            mobj.srcTitle = items[i].origin.title
            mobj.url = items[i].alternate[0].href
            mobj.isRead = false
            mobj.isLike = false
            mobj.isStar = false
            mobj.isShare = false
            var categories = items[i].categories
            for(var k=0;k<categories.length;k++){
                if(categories[k].search("read$")!=-1){
                    mobj.isRead = true
                }
                if(categories[k].search("like$")!=-1){
                    mobj.isLike = true
                }
                if(categories[k].search("starred$")!=-1){
                    mobj.isStar = true
                }
                if(categories[k].search("broadcast$")!=-1){
                    mobj.isShare = true
                }
            }
            feedModel.append(mobj)
        }
    }



    function loadCache(title,feedid){
        feedModel.clear()
        feedModel.title = title
        feedModel.feedid = feedid
        var cbk = function(rdata,count){
            if(!rdata)
                update(feedid)
            else{
                onData(rdata,count)
            }
        }
        var rdata = Dbm.queryItems(feedid,cbk,0)
    }

    function loadPage(){
        if(page>=total)return

        busy = true
        page +=1

        var cbk = function(rdata,count){
            if(!rdata)
                update(feedid)
            else{
                onData(rdata,count)
            }
        }
        var rdata = Dbm.queryItems(feedid,cbk,page)
    }

    function update(title,feedid){
        if(!sid||!auth){
            message(qsTr("not login"))
            return;
        }
        Dbm.log_info("update feed "+title+" "+feedid)
        feedModel.title = title
        feedModel.feedid= feedid
        var params = {
            output:"json",
            auth:auth,
            sid:sid,
            n:feedMax,
            ck:Number(new Date()),
            client:"scroll",
            sharers:Qt.md5("R2-Touch")
        }
        busy = true

        var cbk = function(rdata){
            var items = JSON.parse(rdata).items
            Dbm.updateItems(feedModel.feedid,items)
            Dbm.queryItems(feedid,onData,page)
        }

        Http.doGet(feedModel.contentSource+feedid,params,cbk,onError)
    }
}
