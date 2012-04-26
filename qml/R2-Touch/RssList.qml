import QtQuick 1.0

Rectangle {
    id:rsslist
    width: 360
    height: 640
    color: "#e6e6e6"

    property string tag
    property string tagid
    signal doHome()
    signal doBack()
    signal doStatus()

    signal feedClick()
    signal message(string msg)


    function updateData(_tag,_tagid){
        tag = _tag
        tagid = _tagid
        if(rsslist.state=="showRsslist"){
            header1.title = tag + qsTr("-rss")
            rssModel.loadCache(tag,tagid)
        }else{
            header1.title = tag + qsTr("-all")
            feedModel.loadCache(tag,tagid)
        }
    }


    function updateModel(){
        if(rsslist.state=="showRsslist")
            rssModel.update(tag,tagid)
        else{
            var _title = feedModel.title?feedModel.title:tag
            var _feedid = feedModel.feedid?feedModel.feedid:tagid
            feedModel.update(_title,_feedid)
        }
    }

    function rssClick(feedid,title){
        rsslist.state = "showFeedlist"
        header1.title = title
        feedModel.loadCache(title,feedid)
    }

    function getCurrentIdx(){
        return feed_list.currentIndex
    }

    function getCurrentObj(){
        return feedModel.get(feed_list.currentIndex)
    }

    function setCurrentObj(obj){
        feedModel.set(feed_list.currentIndex,obj)
    }

    function previous(){
        feed_list.decrementCurrentIndex();
    }

    function next(){
        feed_list.incrementCurrentIndex();
    }

    Header {
        id: header1
        title: "R2-Symbian"
        isBuzy: rssModel.busy||feedModel.busy
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
        leftIcon: "qrc:/qml/R2-Touch/res/32/align_just.png"
        middleIcon: "qrc:/qml/R2-Touch/res/32/playback_reload.png"
        rightIcon: rsslist.state=="showRsslist"?"qrc:/qml/R2-Touch/res/32/rss.png":"qrc:/qml/R2-Touch/res/32/list_bullets.png"
        onClick: {
            if(sign=="L"){
                menu.setModel(mainModel)
                menu.show()
            }else if(sign=="R"){
                rsslist.state = rsslist.state=="showRsslist"?"showFeedlist":"showRsslist"
                updateData(tag,tagid)
            }else{
                updateModel()
            }
        }
    }

    RssModel{
        id:rssModel
        onMessage: rsslist.message(msg)

    }
    FeedModel{
        id:feedModel
        onMessage: rsslist.message(msg)
    }

    ListView {
        id: feed_list
        clip: true
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        x:0;y:header1.height
        width: rsslist.width
        height: rsslist.height-header1.height-footer1.height
        spacing: 2
        model: feedModel
        delegate: ListItem{
            text: title
            width: feed_list.width
            icon: "qrc:/qml/R2-Touch/res/32b/rss.png"
            onClick: {
                feed_list.currentIndex = index
                feed_list.forceActiveFocus()
                rsslist.feedClick()
            }

        }
        onMovementEnded: {
            feedModel.loadPage()
        }
    }

    ListView {
        id: rss_list
        clip: true
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        x:rsslist.width;y:header1.height
        width: rsslist.width
        height: rsslist.height-header1.height-footer1.height
        spacing: 2
        model: rssModel
        delegate: ListItem{
            text: feedtitle
            width: rss_list.width
            icon: "qrc:/qml/R2-Touch/res/32b/rss.png"
            onClick: {
                var obj = rssModel.get(index)
                rsslist.rssClick(obj.feedid,obj.feedtitle)
            }
        }
    }


    states: [
        State {
            name: "showFeedlist"
            PropertyChanges {target: rss_list;x: rsslist.width}
            PropertyChanges {target: feed_list;x: 0}
        },
        State {
            name: "showRsslist"
            PropertyChanges {target: rss_list;x: 0}
            PropertyChanges {target: feed_list;x: -rsslist.width}
        }
    ]
    transitions: Transition {
        PropertyAnimation { properties: "x"; easing.type: Easing.InOutQuad }
    }




    Menu{
        id:menu
        width: Math.min(parent.width,parent.height)-60
        anchors.centerIn: parent
    }

    VisualItemModel{
        id:mainModel
        MenuItem{
            id:mstatus;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/round_and_up.png"
            text: main.online?qsTr("Go offline"):qsTr("Go online")
            onClick: {menu.hide();doStatus()}
        }
//        MenuItem{
//            id:markall;
//            width:menu.menuWidth;
//            icon: "qrc:/qml/R2-Touch/res/32/checkbox_checked.png"
//            text: qsTr("Mark all as read")
//            onClick: {menu.hide();doMarkall()}
//        }
//        MenuItem{
//            id:rename;
//            width:menu.menuWidth;
//            icon: "qrc:/qml/R2-Touch/res/32/tag.png"
//            text: qsTr("Rename folder");
//            onClick: {menu.hide();doRename()}
//        }


    }








}
