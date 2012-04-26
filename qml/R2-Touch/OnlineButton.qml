import QtQuick 1.0

Item {
    id: item1
    width: 360
    height: 64
    property alias name: text1.text
    property bool isOnline: false
    signal click


    Rectangle {
        id: bg
        radius: 10
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 2
        anchors.fill: parent
        opacity: 0.6
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#181818"
            }

            GradientStop {
                position: 0.17
                color: "#202020"
            }

            GradientStop {
                position: 0.96
                color: "#000000"
            }
        }
    }

    Text {
        id: text1
        color: "#ffffff"
        text: isOnline?"Go Offline":"Go Online"
        anchors.centerIn: parent
        style: Text.Raised
    }

    MouseArea{
        id:mouse_area
        anchors.fill: parent
        onClicked: click()
    }


}
