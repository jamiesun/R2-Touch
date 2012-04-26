import QtQuick 1.0
import "dbutils.js" as Dbm
Item {
    id: item1
    width: 360
    height: text1.height +30
    property alias text: text1.text
    property alias icon: icon1.source
    signal click()
    signal longClick()

    Rectangle {
        id: bg
        radius: 10
        opacity: 0.8
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ececec"
            }

            GradientStop {
                id:gstop
                position: 0.96
                color: "#c8c8c8"
            }
        }
        anchors.fill: parent


    }
    Image {
        id: icon1
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.5
        scale: 0.8
        source: "qrc:/qml/R2-Touch/res/32b/tag.png"
    }

    Image {
        id: icon2
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.5
        scale: 0.5
        source: "qrc:/qml/R2-Touch/res/32b/playback_play.png"
    }

    Text {
        id: text1
        text: "text"
        wrapMode: Text.WrapAnywhere
        anchors.right: icon2.left
        anchors.rightMargin: 10
        anchors.left: icon1.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: main.std_font
    }

    MouseArea{
        id:mouse_area
        anchors.fill: parent
        hoverEnabled: true
        onClicked:item1.click()

        onPressAndHold: item1.longClick()
    }
    states: [
        State {
            name: "Pressed"
            when: mouse_area.pressed == true
            PropertyChanges { target: gstop; color:"#ececec"}
        }
    ]
}
