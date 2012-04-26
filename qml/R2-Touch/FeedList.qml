import QtQuick 1.0

Rectangle {
    id:feedlist
    width: 360
    height: 640
    color: "#e6e6e6"

    signal doHome()
    signal doBack()
    signal feedClick()
    signal message(string msg)

    function updateFeed(feedUrl,title){
        feedModel.clear()
        header1.title = title
        feedModel.loadCache(feedUrl)
    }


    function getCurrentIdx(){
        return list_view.currentIndex
    }

    function getCurrentObj(){
        return feedModel.get(list_view.currentIndex)
    }

    function setCurrentObj(obj){
        feedModel.set(list_view.currentIndex,obj)
    }

    function previous(){
        list_view.decrementCurrentIndex();
    }

    function next(){
        list_view.incrementCurrentIndex();
    }

    Header {
        id: header1
        title: "R2-Symbian"
        isBuzy: feedModel.busy
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    Footer {
        id: footer1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        leftIcon: "qrc:/qml/R2-Touch/res/32/home.png"
        middleIcon: "qrc:/qml/R2-Touch/res/32/playback_reload.png"
        rightIcon: "qrc:/qml/R2-Touch/res/32/undo.png"
        onClick: {
            if(sign=="L"){
                doHome()
            }else if(sign=="R"){
                doBack()
            }else{
                feedModel.update(feedModel.feedUrl)
            }
        }
    }



    FeedModel{
        id:feedModel
        onMessage: feedlist.message(msg)
    }

    ListView {
        id: list_view
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        clip: true
        anchors.bottomMargin: 0
        anchors.top: header1.bottom
        anchors.right: parent.right
        anchors.bottom: footer1.top
        anchors.left: parent.left
        anchors.topMargin: 0
        spacing: 2
        model: feedModel
        delegate: ListItem{
            text: title
            width: list_view.width
            icon: "qrc:/qml/R2-Touch/res/32b/rss.png"
            onClick: {
                list_view.currentIndex = index
                list_view.forceActiveFocus()
                feedClick()
            }
        }
    }

}
