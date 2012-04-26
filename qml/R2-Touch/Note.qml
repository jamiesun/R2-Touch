import QtQuick 1.0
import "json2.js" as JSON
import "dbutils.js" as Dbm
Rectangle {
    id: notes
    width: 360
    height: 640
    color: "#e6e6e6"
    property string cache_key: "note_drafts"
    property bool sync_flag: false

    signal doTweet(string msg)
    signal doHome
    signal doBack
    signal message(string msg)

    function doSave(){
        if(!ctxIn.ivalue)return
        if(container.flipped)return
        if(!main.token){
            var note_drafts = main.getCache(cache_key)
            var note_tmp = []
            if(note_drafts){
                note_tmp = JSON.parse(note_drafts)
            }
            var nobj = {note_tags:tagsIn.ivalue,note_ctx:ctxIn.ivalue}
            note_tmp.push(nobj)
            main.setCache(cache_key,JSON.stringify(note_tmp))
            draftslist.model.append(nobj)
            message(qsTr("saved"))
            return
        }


        var msg = {snippet:ctxIn.ivalue,auth:main.auth,sid:main.sid,token:main.token}
        if(tagsIn.ivalue) msg.tags = tagsIn.ivalue
        noteWork.sendMessage(msg)
    }

    function doSync(){
        if(!main.token){
            message(qsTr("not login"))
            return
        }
        sync_flag = true
        var sobj = draftslist.model.get(draftslist.currentIndex)
        var msg = {snippet:sobj.note_ctx,auth:main.auth,sid:main.sid,token:main.token}
        if(sobj.note_tags) msg.tags = sobj.note_tags
        noteWork.sendMessage(msg)
    }

    function doDelete(){
        draftslist.model.remove(draftslist.currentIndex)
        var note_tmp = []
        for(var i=0;i<draftslist.model.count;i++){
            note_tmp.push(draftslist.model.get(i))
        }
        main.setCache(cache_key,JSON.stringify(note_tmp))
    }

    function init(){
        var note_drafts = main.getCache(cache_key)
        var note_tmp = []
        if(note_drafts){
            note_tmp = JSON.parse(note_drafts)
        }
        for(var idx in note_tmp){
            draftslist.model.append(note_tmp[idx])
        }
    }

    Component.onCompleted:init()

    WorkerScript {
        id: noteWork;source: "createnote.js"
        onMessage:{
            notes.message(messageObject.msg)
            Dbm.log_info("createnote "+messageObject.msg)
            if(sync_flag){
                sync_flag = false
                doDelete()
            }
        }
    }

    Header {
        id: header1
        title: "Add Note"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        onDoLeft: doHome()
        onDoRight: doBack()
    }

    Footer {
        id: footer1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        leftIcon: "qrc:/qml/R2-Touch/res/32/save.png"
        middleIcon: container.flipped?"qrc:/qml/R2-Touch/res/32/doc_edit.png":"qrc:/qml/R2-Touch/res/32/list_bullets.png"
        rightIcon: "qrc:/qml/R2-Touch/res/32/twitter_2.png"
        onClick: {
            if(sign=="L"){
                doSave()
            }else if(sign=="R"){
                doTweet(ctxIn.ivalue)
            }else{
                container.flip()
            }
        }
    }

    FlipBox{
        id:container
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: footer1.top
        anchors.bottomMargin: 0
        anchors.top: header1.bottom
        anchors.topMargin: 0

        front: Item{
            id: item1
            anchors.fill: parent
            Input{
                id:tagsIn; height: 65; anchors.right: parent.right; anchors.left: parent.left; anchors.top: parent.top; anchors.rightMargin: 5; anchors.leftMargin: 5; anchors.topMargin: 5;iname: qsTr("Tags:");
                ivalue: ""
            }
            InputArea{
                id:ctxIn
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: tagsIn.bottom
                anchors.topMargin: 5
                ivalue: ""
            }
        }
        back: Item{
            anchors.fill: parent
            ListView {
                id: draftslist
                clip: true
                anchors.fill: parent
                spacing: 2
                model: ListModel{}
                delegate: ListItem{
                    property string tags_: note_tags
                    property string note_: note_ctx
                    text: note_.length>24?note_:(note_.substring(0,24)+"...")
                    icon: "qrc:/qml/R2-Touch/res/32b/notepad_2.png"
                    width: draftslist.width
                    onClick: {
                        draftslist.currentIndex = index
                        tagsIn.ivalue = tags_
                        ctxIn.ivalue = note_
                        container.flip()
                    }
                    onLongClick: {
                        draftslist.currentIndex = index
                        menu.setModel(mainModel)
                        menu.show()
                    }
                }
            }
        }
    }
    Menu{
        id:menu
        width: Math.min(parent.width,parent.height)-60
        anchors.centerIn: parent
    }

    VisualItemModel{
        id:mainModel
        MenuItem{
            id:msync;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/network.png"
            text: qsTr("Sync")
            onClick: {menu.hide();doSync()}
        }
        MenuItem{
            id:mdel;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/round_delete.png"
            text: qsTr("Delete")
            onClick: {menu.hide();doDelete()}
        }

    }

}
