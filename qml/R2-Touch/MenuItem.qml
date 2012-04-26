import QtQuick 1.0
import "dbutils.js" as Dbm
Item {
    id: mitem
    width: 360
    height: 48
    property alias text: mtext.text
    property bool checked:false
    property alias icon: icon_.source
    signal click()
    Rectangle {
        id: bg
        radius: 10
        color: "#ffffff"
        opacity: 0
        anchors.rightMargin: 1
        anchors.leftMargin: 1
        anchors.bottomMargin: 1
        anchors.topMargin: 1
        anchors.fill: parent


    }

    Text {
        id: mtext
        color: "#ffffff"
        text: "text"
        anchors.verticalCenterOffset: 0
        style: Text.Raised
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon_.right
        anchors.leftMargin: 10
        font.pointSize: main.std_font
    }

    MouseArea {
        id: mouse_area1
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            mitem.click()
            Dbm.log_info("menu click:"+mitem.text)
        }
    }

    Image {
        id: chkimg
        anchors.verticalCenterOffset: 0
        scale: 0.7
        opacity: 0.8
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        source: checked?"qrc:/qml/R2-Touch/res/32/checkmark.png":""
    }

    Image {
        id: icon_
        anchors.verticalCenterOffset: 0
        scale: 0.9
        opacity: 0.9
        smooth: true
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/R2-Touch/res/32/star.png"
        Behavior on opacity{NumberAnimation{duration: 50}}

    }
    Image {
        id: iPressed
        width: 58
        height: 58
        anchors.centerIn: icon_
        scale: 1.0
        opacity: 0
        source: "qrc:/qml/R2-Touch/res/mh.png"
        Behavior on opacity{NumberAnimation{duration: 50}}
    }

    Image {
        id: image1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        source: "qrc:/qml/R2-Touch/res/line.png"
    }

    states: [
        State {
            name: "Pressed"
            when: mouse_area1.pressed == true
            PropertyChanges { target: iPressed; opacity:1}
            PropertyChanges { target: icon_; opacity:0.5}
        }
    ]
}
