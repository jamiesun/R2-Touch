import QtQuick 1.0

Rectangle {
    id:loglist
    width: 360
    height: 640
    color: "#e6e6e6"


    signal message(string msg)

    signal doHome


    function updateLogss(){
        logsModel.loadData()
    }



    Header {
        id: header1
        title: "R2-Logs"
        isBuzy: logsModel.busy
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        righticon: "qrc:/qml/R2-Touch/res/32/playback_reload.png"
        onDoLeft: doHome()
        onDoRight: updateLogss()
    }





    LogsModel{
        id:logsModel
        onMessage: loglist.message(msg)
    }

    ListView {
        id: list_view
        clip: true
        anchors.bottomMargin: 0
        anchors.top: header1.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        spacing: 2
        model: logsModel
        delegate: ListItem{
            text: logdesc
            icon: ""
            width: list_view.width
        }
    }




}
