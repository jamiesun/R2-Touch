import QtQuick 1.0

Rectangle {
    id: rectangle1
    width: 360
    height: 120
    color: "#e4e4e4"
    radius: 0
    property bool isFollow: false
    signal follow()



    Text {
        id: t1
        x: 14
        y: 13
        width: 80
        height: 20
        color: "#2b2b2b"
        text: "R2 Touch V1.0.1"
        anchors.left: parent.left
        anchors.leftMargin: 18

        anchors.top: parent.top
        anchors.topMargin: 10
        font.pointSize: main.tiny_font
    }

    Text {
        id: t2
        x: 14
        y: 40
        width: 80
        height: 20
        color: "#2b2b2b"
        text: "Support : jamiesun.net@gmail.com"
        anchors.top: t1.bottom
        anchors.topMargin: 10
        font.pointSize: main.tiny_font
        anchors.leftMargin: 18
        anchors.left: parent.left
    }
    Button {
        id: button1
        width: 137
        height: 40
        radius: 8
        text: isFollow?"Following":"Follow"
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.top: t2.bottom
        anchors.topMargin: 10
        onClick: follow()
   }

}
