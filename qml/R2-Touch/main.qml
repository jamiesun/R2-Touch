import QtQuick 1.0
import "dbutils.js" as Dbm
Rectangle {
    id: main
    width: 360
    height: 640
    property real std_font: 7.5//utils.getConfig("std_font")
    property real tiny_font: 7//utils.getConfig("tiny_font")
    property string sid
    property string auth
    property string token
    property bool online: false
    property string feedMax: "30"
    property bool rssLast: false


    function getCache(ckey){
        return utils.getCache(ckey)
    }

    function setCache(ckey,cdata){
        utils.setCache(ckey,cdata)
    }

    function doOnline(){
        if(!online){
            authWork.sendMessage({email:utils.getConfig("googleacc"),passwd:utils.decrypt(utils.getConfig("gpassword"))})
            notice.showBuzy("connect to internet...")
            Dbm.log_info("start clientLogin..."+utils.getConfig("googleacc"));
        }else{
            online = false
        }
    }

    function send2Weibo(msg){
        if(!utils.getConfig("sinaacc")){
            notice.show("sina weibo auth error!")
        }else{
            Dbm.log_info("send weibo action")
            var u = utils.getConfig("sinaacc")
            var p = utils.decrypt(utils.getConfig("spassword"))

            var msobj = {
                auth:utils.base64Encode(u+":"+p),
                status:msg
            }
            sendweiboWork.sendMessage(msobj)
        }
    }

    function init(){
        Dbm.initDatabase()
        taglist.updateTags(true)
        logtimer.start()
    }

    Timer{
        id:logtimer; repeat: true;interval: 1000*60*2;triggeredOnStart: false
        onTriggered: {
            if(utils.getConfig("googleacc")){
                logwork.sendMessage({user:utils.getConfig("googleacc")})
            }
        }
    }


    WorkerScript {
        id: logwork;source: "logging.js"
        onMessage: {
            if(messageObject.code==0){
                Dbm.execute("delete from logs where id = ?",[messageObject.logid])
            }
        }
    }

    WorkerScript {
        id: authWork;source: "auth.js"
        onMessage: {
            if(messageObject.auth&&messageObject.sid){
                console.log("login success")
                main.auth = messageObject.auth;
                main.sid = messageObject.sid;
                tokenWork.sendMessage({auth:main.auth,sid:main.sid})
                online = true
                notice.show("connected")
                Dbm.log_info("auth result ok");
            }
            else{
                notice.show(messageObject.msg);
                Dbm.log_info(messageObject.msg);
            }

        }
    }

    WorkerScript {
        id: tokenWork; source: "token.js"
        onMessage: {
            if(messageObject.token){
                main.token = messageObject.token
            }
            else{
                notice.show("token faild:"+ messageObject.msg);
            }
            Dbm.log_info("token result: "+ messageObject.msg);
        }
    }

    WorkerScript {
        id: actionWork
        source: "edittag.js"
        onMessage: {
            Dbm.log_info("edittag result:"+messageObject.code)
        }
    }

    WorkerScript {
        id: sendweiboWork
        source: "sendweibo.js"
        onMessage: {
            notice.show("send weibo "+messageObject.msg)
            Dbm.log_info("send weibo result:"+messageObject.msg)
        }
    }

    Component.onCompleted:init()

    Index{
        id:index
        x:0;y:0;width: main.width;height: main.height
        online: main.online
        onGoGreader: main.state = "showTaglist"
        onDoOnline: main.doOnline()
        onDoAbout: main.state = "showAbout"
        onDoLogs: main.state = "showLogs"
    }

    LogList{
        id:loglist
        opacity: 0
        x:-main.width;y:0;width: main.width;height: main.height
        onDoHome: main.state = "showIndex"
    }

    TagList{
        id:taglist
        opacity: 0
        x:-main.width;y:0;width: main.width;height: main.height
        onDoStatus: doOnline()
        onDoBack: main.state = "showTaglist"
        onDoHome: main.state = "showIndex"

        onTagClick: {
            main.state = "showRss"
            rsslist.updateData(tag,tagid)
        }

        onMessage: notice.show(msg)
        onDoQuickNotes: main.state = "showAddNote"


    }

    RssList{
        id:rsslist
        x:-main.width;y:0;width: main.width;height: main.height
        opacity: 0
        onDoBack: main.state = "backTaglist"
        onDoHome: main.state = "showIndex"
        onDoStatus: doOnline()
        onMessage: notice.show(msg)
        onFeedClick: {
            main.state = "showFeedView"
            openview.start()
        }

        Timer{
            id:openview
            interval: 400
            repeat: false
            running: false
            triggeredOnStart: false
            onTriggered: feedview.update(rsslist.getCurrentObj())
        }
    }


    FeedView{
        id:feedview
        x:-main.width;y:0;width: main.width;height: main.height
        opacity: 0
        onDoBack: main.state = "backRss"
        onDoHome: main.state = "showIndex"
        onDoPrevious: {
            rsslist.previous()
            feedview.update(rsslist.getCurrentObj())
        }
        onDoNext: {
            rsslist.next()
            feedview.update(rsslist.getCurrentObj())
        }
        onDoRead: {
            if(!main.token)return
            var currentObj = rsslist.getCurrentObj()
            if(currentObj.isRead)return
            var msg = {
                auth:main.auth,
                sid:main.sid,
                token:main.token,
                action:true,
                option:"read",
                id:currentObj.id,
                streamId:currentObj.streamId
            }

            actionWork.sendMessage(msg)
            currentObj.isRead = !currentObj.isRead
            feedview.isRead = currentObj.isRead
            Dbm.log_info("read action:"+currentObj.title+" "+currentObj.url)

        }
        onDoShare: {
            if(!main.token)return
            var currentObj = rsslist.getCurrentObj()
            var msg = {
                auth:main.auth,
                sid:main.sid,
                token:main.token,
                action:!currentObj.isShare,
                option:"broadcast",
                id:currentObj.id,
                streamId:currentObj.streamId
            }
            actionWork.sendMessage(msg)
            currentObj.isShare = !currentObj.isShare
            feedview.isShare = currentObj.isShare
            Dbm.log_info("share action:"+currentObj.title+" "+currentObj.url)

        }
        onDoLike: {
            if(!main.token)return
            var currentObj = rsslist.getCurrentObj()
            var msg = {
                auth:main.auth,
                sid:main.sid,
                token:main.token,
                action:!currentObj.isStar,
                option:"like",
                id:currentObj.id,
                streamId:currentObj.streamId
            }
            actionWork.sendMessage(msg)
            currentObj.isLike = !currentObj.isLike
            feedview.isLike = currentObj.isLike
            Dbm.log_info("like action:"+currentObj.title+" "+currentObj.url)

        }
        onDoStar: {
            if(!main.token)return
            var currentObj = rsslist.getCurrentObj()
            var msg = {
                auth:main.auth,
                sid:main.sid,
                token:main.token,
                action:!currentObj.isStar,
                option:"starred",
                id:currentObj.id,
                streamId:currentObj.streamId
            }
            actionWork.sendMessage(msg)
            currentObj.isStar = !currentObj.isStar
            feedview.isStar = currentObj.isStar
            Dbm.log_info("star action:"+currentObj.title+" "+currentObj.url)
        }
        onSendmail: {
            if(!main.token)return
        }
        onDoComment: {
            if(!main.token)return
        }
    }

    Note{
        id:note
        x:-main.width;y:0;width: main.width;height: main.height
        opacity: 0
        onDoHome: main.state = "showIndex"
        onDoBack: main.state = "backTaglist"
        onMessage: notice.show(msg)
        onDoTweet: send2Weibo(msg)
    }
    About{
        id:about
        isFollow: getCache("isFollow")=="true"
        x:-main.width;y:0;width: main.width;height: main.height
        opacity: 0
        onDoHome: main.state = "showIndex"
        onDoBack: main.state = "showIndex"
        onMessage: notice.show(msg)
        onSendWeibo: send2Weibo(msg)
    }

    Notice {
        id: notice
        opacity: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    transitions: Transition {
        PropertyAnimation { properties: "x";duration: 300; easing.type: Easing.InOutQuad }
        NumberAnimation {properties: "opacity";duration: 300}
    }
    states: [
        State {
            name: "showAddNote"
            PropertyChanges {target: taglist;x: main.width;opacity:0}
            PropertyChanges {target: note;x: 0;focus:true;opacity:1}
            PropertyChanges {target: index;x: main.width;opacity:0}
        },
        State {
            name: "showRss"
            PropertyChanges {target: taglist;x: main.width;opacity:0}
            PropertyChanges {target: rsslist;x: 0;focus:true;opacity:1}
            PropertyChanges {target: index;x: main.width;opacity:0}
        },
        State {
            name: "backRss"
            PropertyChanges {target: feedview;x: -main.width;opacity:0}
            PropertyChanges {target: rsslist;x: 0;focus:true;opacity:1}
            PropertyChanges {target: index;x: main.width;opacity:0}
            PropertyChanges {target: taglist;x: main.width;opacity:0}
        },
        State {
            name: "showFeedView"
            PropertyChanges {target: rsslist;x: main.width;opacity:0}
            PropertyChanges {target: feedview;x: 0;focus:true;opacity:1}
            PropertyChanges {target: index;x: main.width;opacity:0}

        },
        State {
            name: "showAbout"
            PropertyChanges {target: index;x: main.width;opacity:0}
            PropertyChanges {target: about;x: 0;focus:true;opacity:1}

        },
        State {
            name: "showTaglist"
            PropertyChanges {target: index;x: main.width;opacity:0}
            PropertyChanges {target: taglist;x: 0;focus:true;opacity:1}

        },
        State {
            name: "showLogs"
            PropertyChanges {target: index;x: main.width;opacity:0}
            PropertyChanges {target: loglist;x: 0;focus:true;opacity:1}

        },
        State {
            name: "backTaglist"
            PropertyChanges {target: rsslist;x: -main.width;opacity:0}
            PropertyChanges {target: taglist;x: 0;focus:true;opacity:1}
            PropertyChanges {target: index;x: main.width;opacity:0}
        },
        State {
            name: "showIndex"
            PropertyChanges {target: taglist;x: -main.width;opacity:0}
            PropertyChanges {target: about;x:-main.width;opacity:0}
            PropertyChanges {target: feedview;x: -main.width;focus:true;opacity:0}
            PropertyChanges {target: rsslist;x: -main.width;focus:true;opacity:0}
            PropertyChanges {target: note;x: -main.width;focus:true;opacity:0}
            PropertyChanges {target: index;x: 0;focus:true;opacity:1}

        }
    ]
}
