import QtQuick 1.0
import "json2.js" as Json
import "http.js" as Http
import "dbutils.js" as Dbm
ListModel{
    id:tagsModel
    property string sid:main.sid
    property string auth:main.auth
    property string source: "https://www.google.com/reader/api/0/tag/list"
    property string subsource: "https://www.google.com/reader/api/0/subscription/list"
    property bool busy: false
    signal message(string msg)

    function onError(err){
        message(err)
        busy = false
    }

    function onData(result){
        busy = false
        tagsModel.clear()
        for(var idx in result){
            var _tagid = result[idx].id
            var _tagname = result[idx].name
            var _unread = result[idx].unread
            if(_tagname!="starred"&&_tagname!="broadcast")
                tagsModel.append({tagname:_tagname,tagid:_tagid,unread:_unread})
        }
    }

    function loadCache(){
        var cbk = function(tags){
            if(!tags){
                if(auth&&sid)update()
            }else{
                onData(tags)
            }
        }
        Dbm.queryTags(cbk)
    }

    function update(){
        if(!sid||!auth){
            message("not login")
            return;
        }
        Dbm.log_info("update tag")
        var params = {
            output:"json",
            auth:auth,
            sid:sid
        }
        busy = true

        var cbk = function(rdata){
            var result = JSON.parse(rdata)['tags']
            var tags_tmp = []
            for(var i=0;i<result.length;i++){
                var tagid = result[i].id
                var tagname = tagid.substr(tagid.lastIndexOf('/')+1)
                tags_tmp.push({id:tagid,name:tagname,unread:0})
            }
            Dbm.updateTags(tags_tmp)
            Dbm.queryTags(onData)
        }

        var subscbk = function(rdata){
            var result = JSON.parse(rdata)['subscriptions']
            Dbm.updateSubs(result)
            main.rssLast = true
        }

        Http.doGet(source,params,cbk,onError)
        Http.doGet(subsource,params,subscbk,onError)


    }

}
