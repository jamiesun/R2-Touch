import QtQuick 1.0
import "json2.js" as JSON
import "dbutils.js" as Dbm
Rectangle {
    id:about
    width: 360
    height: 640
    color: "#e6e6e6"
    Component{id:ver;Version{}}
    property bool isFollow: false


    signal doBack
    signal doHome
    signal message(string msg)
    signal sendWeibo(string msg)

    function update(){
       aboutModel.reload()
    }

    function follow(){
         if(isFollow)return
         if(!main.token){
             message(qsTr("not login"))
         }else{
             followWork.sendMessage({auth:main.auth,sid:main.sid,token:main.token})
         }
    }

    WorkerScript {
        id: followWork; source: "follow.js"
        onMessage: {
            if(messageObject.code==0){
                main.setCache("isFollow","true")
                isFollow = true
            }
            else{
                main.setCache("isFollow","false")
            }
            Dbm.log_info("follow result: "+messageObject.code);
        }
    }

    Header {
        id: header1
        title: "About R2"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        isBuzy: aboutModel.status == XmlListModel.Loading
        onDoLeft: doHome()
        onDoRight: doHome()
    }

    Footer {
        id: footer1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        leftIcon: "qrc:/qml/R2-Touch/res/32/playback_reload.png"
        middleIcon: ""
        middleText: "Share"
        rightIcon: "qrc:/qml/R2-Touch/res/32/spechbubble_sq_line.png"
        onClick: {
            if(sign=="L"){
                update()
            }else if(sign=="R"){
                feedback.opacity = feedback.opacity==0?1:0
            }else{
                sendWeibo("#R2分享#:R2是一个Qt Quick开发的移动平台阅读工具，支持googlereader，新浪微博，当前主要支持symbian平台，赶快来试一试吧，http://code.google.com/p/r2-release")
            }
        }
    }
    Author{
        id:author
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: header1.bottom
        anchors.topMargin: 0
        isFollow: about.isFollow
        onFollow: about.follow()
    }


    XmlListModel{
        id:aboutModel
        source:"http://r2-release.googlecode.com/svn/trunk/r2-updates.xml"
        query: "/items/version"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "url"; query: "url/string()" }
        XmlRole { name: "content"; query: "content/string()" }

    }

    ListView {
        id: list_view
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        clip: true
        anchors.bottomMargin: 0
        anchors.top: author.bottom
        anchors.right: parent.right
        anchors.bottom: footer1.top
        anchors.left: parent.left
        anchors.topMargin: 0
        spacing: 2
        model: aboutModel
        delegate: Version{
            id:version
            width: list_view.width
            ititle:title
            iurl: url
            icontent: content
        }
    }

    Feedback {
        id: feedback
        opacity: 0
        x: 0
        y: about.height - feedback.height
        Behavior on opacity{NumberAnimation{duration: 200}}
        onSend: {
            feedback.opacity = 0
            sendWeibo("@jamiesun #R2反馈# : "+msg)
        }
        onCancel: feedback.opacity = 0

    }

}
